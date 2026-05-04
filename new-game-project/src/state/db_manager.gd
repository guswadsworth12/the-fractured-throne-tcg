## DBManager.gd
## Godot 4 Autoload singleton for PostgreSQL communication.
## REQUIRES: bridge.py running on localhost:8000
## Start with: bash db/start_bridge.sh
extends Node

class_name DBManager

const CardData = preload("res://src/cards/card_data.gd")
const UnitCard = preload("res://src/cards/unit_card.gd")
const BurstCard = preload("res://src/cards/burst_card.gd")
const AugmentCard = preload("res://src/cards/augment_card.gd")
const RiftCard = preload("res://src/cards/rift_card.gd")

#region SIGNALS
signal db_connected()
signal db_connection_failed(error: String)
signal card_loaded(card: CardData)
signal cards_loaded(cards: Array)
signal deck_validated(deck_id: String, is_valid: bool, errors: Array)
signal balance_check_complete(results: Array)
signal faction_data_loaded(faction_id: int, data: Dictionary)
signal query_failed(query_type: String, error: String)
#endregion

#region STATE
var base_url: String = "http://localhost:8000"
var _is_connected_to_bridge: bool = false

## Cache structure: { id: { "data": CardData, "timestamp": int } }
var card_cache: Dictionary = {}
var faction_cache: Dictionary = {}
var keyword_cache: Dictionary = {}
var pending_requests: Array = []

const CACHE_EXPIRY_MS := 300000 ## 5 minutes
#endregion

#region SQL CONSTANTS
const SQL_LOAD_CARD := """
	SELECT c.*, f.name as faction_name,
		array_agg(k.name) as keywords
	FROM cards c
	JOIN factions f ON c.faction_id = f.id
	LEFT JOIN card_keywords ck ON c.id = ck.card_id
	LEFT JOIN keywords k ON ck.keyword_id = k.id
	WHERE c.id = $1
	GROUP BY c.id, f.name
"""

const SQL_LOAD_FACTION_CARDS := """
	SELECT c.*, f.name as faction_name,
		array_agg(k.name) as keywords
	FROM cards c
	JOIN factions f ON c.faction_id = f.id
	LEFT JOIN card_keywords ck ON c.id = ck.card_id
	LEFT JOIN keywords k ON ck.keyword_id = k.id
	WHERE f.name = $1
	GROUP BY c.id, f.name
	ORDER BY c.rank_cost, c.name
"""

const SQL_BALANCE_CHECK := "SELECT * FROM balance_check ORDER BY status DESC, faction, rank_cost"

const SQL_FACTION_POWER := "SELECT power_tendency, ability_tendency FROM factions WHERE name = $1"

const SQL_POWER_CAPS := "SELECT * FROM power_caps WHERE rank = $1"
#endregion

#region INITIALIZATION
func _ready():
	## Connect to TurnManager if available
	var tm = get_node_or_null("/root/TurnManager")
	if tm:
		tm.turn_started.connect(_on_turn_started)
	
	check_connection()

func _on_turn_started(player: int) -> void:
	load_active_deck_state(player)

func check_connection() -> void:
	var response = await _http_get("/health")
	if response.has("status") and response["status"] == "ok":
		_is_connected_to_bridge = true
		emit_signal("db_connected")
		print("DBManager: Connected to PostgreSQL bridge.")
	else:
		_is_connected_to_bridge = false
		var msg = "PostgreSQL bridge not running. Start bridge.py first:\ncd /home/rend/Projects/the-fractured-throne-tcg/db\npython bridge.py"
		emit_signal("db_connection_failed", msg)
		push_error("DBManager: " + msg)
#endregion

#region CORE QUERY
## Core query function — all others call this
## Always async — never blocks main thread
func query(sql: String, params: Array) -> Dictionary:
	var body = {
		"sql": sql,
		"params": params
	}
	
	var response = await _http_post("/query", body)
	
	if response.has("error"):
		emit_signal("query_failed", "SQL_QUERY", response["error"])
		return {}
	
	return response

func _http_get(path: String) -> Dictionary:
	var client = HTTPClient.new()
	var err = client.connect_to_host("127.0.0.1", 8000)
	if err != OK:
		return {"error": "Connection failed"}
	
	while client.get_status() == HTTPClient.STATUS_CONNECTING or client.get_status() == HTTPClient.STATUS_RESOLVING:
		client.poll()
		await get_tree().process_frame
	
	if client.get_status() != HTTPClient.STATUS_CONNECTED:
		return {"error": "Connection failed"}
	
	client.request(HTTPClient.METHOD_GET, path, [])
	
	while client.get_status() == HTTPClient.STATUS_REQUESTING:
		client.poll()
		await get_tree().process_frame
	
	if client.get_status() != HTTPClient.STATUS_BODY and client.get_status() != HTTPClient.STATUS_CONNECTED:
		return {"error": "Request failed"}
	
	var rb = PackedByteArray()
	while client.get_status() == HTTPClient.STATUS_BODY:
		client.poll()
		var chunk = client.read_response_body_chunk()
		if chunk.size() == 0:
			await get_tree().process_frame
		else:
			rb.append_array(chunk)
	
	var json = JSON.new()
	var parse_err = json.parse(rb.get_string_from_utf8())
	if parse_err != OK:
		return {"error": "JSON parse failed"}
	
	return json.get_data()

func _http_post(path: String, body: Dictionary) -> Dictionary:
	var client = HTTPClient.new()
	var err = client.connect_to_host("127.0.0.1", 8000)
	if err != OK:
		return {"error": "Connection failed"}
	
	while client.get_status() == HTTPClient.STATUS_CONNECTING or client.get_status() == HTTPClient.STATUS_RESOLVING:
		client.poll()
		await get_tree().process_frame
	
	if client.get_status() != HTTPClient.STATUS_CONNECTED:
		return {"error": "Connection failed"}
	
	var query_str = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	client.request(HTTPClient.METHOD_POST, path, headers, query_str)
	
	while client.get_status() == HTTPClient.STATUS_REQUESTING:
		client.poll()
		await get_tree().process_frame
	
	if client.get_status() != HTTPClient.STATUS_BODY and client.get_status() != HTTPClient.STATUS_CONNECTED:
		return {"error": "Request failed"}
	
	var rb = PackedByteArray()
	while client.get_status() == HTTPClient.STATUS_BODY:
		client.poll()
		var chunk = client.read_response_body_chunk()
		if chunk.size() == 0:
			await get_tree().process_frame
		else:
			rb.append_array(chunk)
	
	var json = JSON.new()
	var parse_err = json.parse(rb.get_string_from_utf8())
	if parse_err != OK:
		return {"error": "JSON parse failed"}
	
	return json.get_data()
#endregion

#region CARD LOADING
func load_card(card_id: int) -> CardData:
	## Check card_cache first
	if card_cache.has(card_id):
		var entry = card_cache[card_id]
		if Time.get_ticks_msec() - entry["timestamp"] < CACHE_EXPIRY_MS:
			emit_signal("card_loaded", entry["data"])
			return entry["data"]
	
	var res = await query(SQL_LOAD_CARD, [card_id])
	if res.is_empty() or res["rows"].is_empty():
		return null
	
	var row = res["rows"][0]
	var card = map_row_to_card(row)
	
	## Store in card_cache
	card_cache[card_id] = {
		"data": card,
		"timestamp": Time.get_ticks_msec()
	}
	
	emit_signal("card_loaded", card)
	return card

func load_faction_cards(faction_name: String) -> Array:
	var res = await query(SQL_LOAD_FACTION_CARDS, [faction_name])
	if res.is_empty():
		return []
	
	var cards = []
	for row in res["rows"]:
		var card = map_row_to_card(row)
		cards.append(card)
		
		## Cache results
		card_cache[int(card.id)] = {
			"data": card,
			"timestamp": Time.get_ticks_msec()
		}
	
	emit_signal("cards_loaded", cards)
	return cards

func load_active_deck_state(player: int) -> void:
	## Placeholder for TurnManager turn_started integration
	## In a real game, this would query the player's current deck
	print("DBManager: Loading active deck state for player ", player)
#endregion

#region DECK VALIDATION
func validate_deck(deck_cards: Array) -> Dictionary:
	var errors = []
	var is_valid = true
	
	# Total cards = 50
	if deck_cards.size() != 50:
		is_valid = false
		errors.append("Deck must contain exactly 50 cards (Current: %d)" % deck_cards.size())
	
	# All cards same faction
	var faction = ""
	var rift_count = 0
	var counts = {} ## { name: count }
	var unique_counts = {} ## { name: count }
	var advance_targets = { 2: 0, 3: 0, 4: 0 }
	var rank1_generals = 0
	
	for card in deck_cards:
		if card.card_type == "Rift":
			rift_count += 1
		else:
			if faction == "":
				faction = card.faction_name
			elif faction != card.faction_name:
				is_valid = false
				errors.append("Multi-faction deck not allowed: %s and %s" % [faction, card.faction_name])
		
		# Copy limits
		counts[card.name] = counts.get(card.name, 0) + 1
		if card.is_unique:
			unique_counts[card.name] = unique_counts.get(card.name, 0) + 1
		
		if counts[card.name] > card.copy_limit:
			is_valid = false
			errors.append("Copy limit exceeded for %s: %d/%d" % [card.name, counts[card.name], card.copy_limit])
		
		if card.is_unique and unique_counts[card.name] > 1:
			is_valid = false
			errors.append("Unique card limit exceeded for %s" % card.name)
		
		# Advance targets
		if card.card_type == "Unit" and card.rank_cost > 1:
			advance_targets[card.rank_cost] = advance_targets.get(card.rank_cost, 0) + 1
		
		# Rank 1 General candidate
		if card.card_type == "Unit" and card.rank_cost == 1 and card.is_general_eligible:
			rank1_generals += 1

	# Max 3 Rift cards total
	if rift_count > 3:
		is_valid = false
		errors.append("Max 3 Rift cards allowed (Current: %d)" % rift_count)
	
	# At least 2 Advance targets per intended Rank
	for rank in [2, 3, 4]:
		if advance_targets[rank] > 0 and advance_targets[rank] < 2:
			is_valid = false
			errors.append("At least 2 cards of Rank %d required to advance (Current: %d)" % [rank, advance_targets[rank]])
	
	# At least 1 legal Rank 1 General candidate
	if rank1_generals == 0:
		is_valid = false
		errors.append("Deck must contain at least 1 legal Rank 1 General candidate")

	var results = { "valid": is_valid, "errors": errors }
	emit_signal("deck_validated", "LOCAL_DECK", is_valid, errors)
	return results
#endregion

#region BALANCE & ANALYTICS
func run_balance_check() -> Array:
	var res = await query(SQL_BALANCE_CHECK, [])
	if res.is_empty():
		return []
	
	emit_signal("balance_check_complete", res["rows"])
	return res["rows"]

func get_faction_power_identity(faction_name: String) -> Dictionary:
	var res = await query(SQL_FACTION_POWER, [faction_name])
	if res.is_empty() or res["rows"].is_empty():
		return {}
	return res["rows"][0]

func get_power_cap(rank: int) -> Dictionary:
	var res = await query(SQL_POWER_CAPS, [rank])
	if res.is_empty() or res["rows"].is_empty():
		return {}
	return res["rows"][0]
#endregion

#region MAPPING
func map_row_to_card(row: Dictionary) -> CardData:
	var card: CardData
	var type = row.get("card_type", "Unit")
	
	match type:
		"Unit":
			card = UnitCard.new()
			card.power = int(row.get("power", 0))
			card.unit_subtype = row.get("unit_subtype", "")
			card.frontline_ability = row.get("frontline_ability", "")
			card.backline_ability = row.get("backline_ability", "")
			card.command_ability = row.get("command_ability", "")
			card.is_general_eligible = bool(row.get("is_general_eligible", false))
		"Burst":
			card = BurstCard.new()
			card.burst_subtype = row.get("burst_subtype", "")
			card.effect_text = row.get("effect_text", "")
		"Augment":
			card = AugmentCard.new()
			card.augment_subtype = row.get("augment_subtype", "")
			card.effect_text = row.get("effect_text", "")
		"Rift":
			card = RiftCard.new()
			card.effect_text = row.get("effect_text", "")
		_:
			card = CardData.new()
	
	# Shared fields
	card.id = int(row.get("id", 0))
	card.name = row.get("name", "Unknown")
	card.faction_name = row.get("faction_name", "")
	card.rank_cost = int(row.get("rank_cost", 0))
	card.is_unique = bool(row.get("is_unique", false))
	card.copy_limit = int(row.get("copy_limit", 3))
	card.flavor_text = row.get("flavor_text", "")
	card.set_code = row.get("set_code", "SET1")
	card.art_path = row.get("art_path", "")
	
	# Keywords: psycopg2 RealDictCursor returns list for array_agg
	var kws = row.get("keywords", [])
	if kws == null:
		card.keywords = []
	elif typeof(kws) == TYPE_STRING:
		# If somehow it's a PG array string "{kw1,kw2}"
		card.keywords = kws.strip_edges().trim_prefix("{").trim_suffix("}").split(",")
	else:
		card.keywords = kws
		
	return card
#endregion