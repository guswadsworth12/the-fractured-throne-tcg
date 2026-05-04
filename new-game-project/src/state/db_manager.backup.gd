## DBManager.gd
## Central database access layer for The Fracture Throne TCG.
## Godot 4 Autoload singleton using GDScript 4 only.
##
## REQUIRES: bridge.py running on http://localhost:8000
## Start with:
##     cd /home/rend/Projects/the-fractured-throne-tcg/db
##     bash start_bridge.sh
##
## NEVER connect to PostgreSQL directly from GDScript.
## All database requests routed through HTTP bridge using HTTPClient.
## All queries are asynchronous (await).
##
## Signals emitted:
## - db_connected()
## - db_connection_failed(error: String)
## - card_loaded(card: CardData)
## - cards_loaded(cards: Array)
## - deck_validated(deck_id: String, is_valid: bool, errors: Array)
## - balance_check_complete(results: Array)
## - faction_data_loaded(faction_id: int, data: Dictionary)
## - query_failed(query_type: String, error: String)

extends Node

class_name DBManager

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
## Godot HTTPClient instance
var http_client: HTTPClient = HTTPClient.new()

## Base URL for the REST bridge
const BASE_URL := "http://localhost:8000"

## Connection status. Updated by check_connection()
var is_connected: bool = false

## In-memory cache of loaded cards.
## { id: CardData }
var card_cache: Dictionary = {}

## Cache timestamps (Unix seconds)
var card_cache_timestamps: Dictionary = {}

## Faction metadata cache
var faction_cache: Dictionary = {}

## Keyword definitions cache
var keyword_cache: Dictionary = {}

## Queued queries when bridge unavailable
var pending_requests: Array = []

## Maximum cache age in seconds
const CACHE_MAX_AGE := 300
#endregion

#region INITIALIZATION
func _ready() -> void:
	## Check database bridge connection.
	## If unavailable, log clear error telling developer to start bridge.
	check_connection()
	_setup_signal_connections()

func _setup_signal_connections() -> void:
	call_deferred("_deferred_signal_connections")

func _deferred_signal_connections() -> void:
	if not has_node("/root/TurnManager"):
		return
	var tm = get_node("/root/TurnManager")
	tm.connect("turn_started", Callable(self, "_on_turn_started"), CONNECT_DEFERRED)

func initialize_http_client() -> void:
	http_client.connect("request_completed", Callable(self, "_handle_response"))
#endregion

#region CONNECTION MANAGEMENT
func check_connection() -> void:
	initialize_http_client()
	var result = http_client.connect_to_host(BASE_URL)
	if result == OK:
		var req_result = http_client.request(HTTPClient.METHOD_GET, "/health", ["User-Agent: Godot", "Accept: application/json"])
		if req_result == OK:
			return
			set_connection_failure("HTTP error: could not request /health")
	else:
		set_connection_failure("Connect failure")

func set_connection_failure(prefix: String) -> void:
	var err = prefix + ". Start bridge.py first:\n"
	var cmd = "cd /home/rend/Projects/the-fractured-throne-tcg/db\nbash start_bridge.sh"
	is_connected = false
	emit_signal("db_connection_failed", err + cmd)
#endregion

#region HTTP CLIENT HELPERS
func _wait_for_response() -> bool:
	while http_client.get_status() == HTTPClient.STATUS_REQUESTING:
		os.delay_msec(50)
	return http_client.get_status() == HTTPClient.STATUS_BODY

func _read_http_body() -> String:
	var response_arr = []
	while http_client.get_status() == HTTPClient.STATUS_BODY:
		var chunk = http_client.read_response_body_chunk()
		if chunk.size() > 0:
			var byte_str = chunk.get_string_from_utf8()
			if byte_str.length() > 0:
			response_arr.append(byte_str)
	return response_arr.join("")

func query(sql: String, params: Array = []) -> Dictionary:
	if not http_client.is_connected_to_host():
		set_connection_failure("Bridge not connected")
		return {}
	
	var body = JSON.print({"sql": sql, "params": params})
	var headers = [
		"Content-Type: application/json",
		"Content-Length: " + str(body.length())
	]
	var req = http_client.request(HTTPClient.METHOD_POST, "/query", headers, body)
	if req != OK:
		var error = "HTTPClient request failed: %d" % [req]
		emit_signal("query_failed", "query", error)
		return {}
	
	if _wait_for_response():
		var body_str = _read_http_body()
		var json = JSON.new()
		var parse_result = json.parse(body_str)
		if parse_result == OK and typeof(json.data) == TYPE_DICTIONARY:
			return json.data
		else:
			var err = "JSON parse failure: " + body_str
			emit_signal("query_failed", "query", err)
	else:
		emit_signal("query_failed", "query", "HTTP request timed out")
	return {}

func _handle_response() -> void:
	var status_code = http_client.get_response_code()
	if status_code != 200:
		var body = _read_http_body()
		var err = "HTTP %d: %s" % [status_code, body]
		emit_signal("query_failed", "http", err)
		return
	
	var body_str = _read_http_body()
	var json = JSON.new()
	var parse_result = json.parse(body_str)
	if parse_result != OK:
		emit_signal("query_failed", "json", "JSON parse failure")
	else:
		var data = json.get_data()
		if typeof(data) == TYPE_DICTIONARY and data.has("status") and data.status == "ok":
			is_connected = true
			emit_signal("db_connected")
		else:
			emit_signal("query_failed", "bridge", str(data))
#endregion

#region CORE QUERY FUNCTIONS
## Maps a database row Dictionary to a CardData instance.
## Handles Unit/Burst/Augment/Rift types.
func map_row_to_card(row: Dictionary) :
	var card = CardData.new()
	card.id = str(row.id)
	card.name = row.get("name", "")
	card.faction_name = row.get("faction_name", "")
	card.card_type = row.get("card_type", "Unit")
	card.rank_cost = row.get("rank_cost", 0)
	card.is_unique = row.get("is_unique", false)
	card.copy_limit = row.get("copy_limit", 3)

	## Keywords: may come as string or array
	var keywords_raw = row.get("keywords", [])
	if typeof(keywords_raw) == TYPE_STRING:
		if keywords_raw.strip().length() > 0 and "," in keywords_raw:
			card.keywords = keywords_raw.split(",").map(func(e: String): return e.strip())
		elif keywords_raw.strip().length() > 0:
			card.keywords = [keywords_raw.strip()]
		else:
			card.keywords = []
	else:
		card.keywords = keywords_raw

	match card.card_type:
		"Unit":
			card.power = row.get("power", 0)
			card.unit_subtype = row.get("unit_subtype", "")
			card.frontline_ability = row.get("frontline_ability", "")
			card.backline_ability = row.get("backline_ability", "")
			card.command_ability = row.get("command_ability", "")
			card.is_general_eligible = row.get("is_general_eligible", false)

		"Burst":
			card.burst_subtype = row.get("burst_subtype", "")
			card.effect_text = row.get("effect_text", "")

		"Augment":
			card.augment_subtype = row.get("augment_subtype", "")
			card.effect_text = row.get("effect_text", "")

		"Rift":
			card.effect_text = row.get("effect_text", "")

	return card

## Core function: load card by ID → cached → emit signal → return CardData
func load_card(card_id: int) :
	var id_str = str(card_id)
	if card_cache.has(id_str):
		var cached = card_cache[id_str]
		if Time.get_unix_time_from_system() - card_cache_timestamps[id_str] < CACHE_MAX_AGE:
			return cached

	var sql := """
	SELECT c.*, f.name as faction_name, 
	 array_agg(k.name) as keywords
	FROM cards c
	LEFT JOIN factions f ON c.faction_id = f.id
	LEFT JOIN card_keywords ck ON c.id = ck.card_id
	LEFT JOIN keywords k ON ck.keyword_id = k.id
	WHERE c.id = $1
	GROUP BY c.id, f.name
	"""

	var result = query(sql, [card_id])
	if not result.has("rows") or result.rows.size() == 0:
		var fallback_card = CardData.new()
		fallback_card.id = id_str
		return fallback_card

	var card = map_row_to_card(result.rows[0])
	card_cache[id_str] = card
	card_cache_timestamps[id_str] = Time.get_unix_time_from_system()
	emit_signal("card_loaded", card)
	return card

## Load all cards for a faction → cached → emit Array → return
func load_faction_cards(faction_name: String) -> Array:
	var sql := """
	SELECT c.*, f.name as faction_name, 
	 array_agg(k.name) as keywords
	FROM cards c
	LEFT JOIN factions f ON c.faction_id = f.id
	LEFT JOIN card_keywords ck ON c.id = ck.card_id
	LEFT JOIN keywords k ON ck.keyword_id = k.id
	WHERE f.name = $1
	GROUP BY c.id, f.name
	ORDER BY c.rank_cost, c.name
	"""

	var result = query(sql, [faction_name])
	var cards: Array = []

	if not result.has("rows"):
		emit_signal("cards_loaded", cards)
		return cards

	for row in result.rows:
		var id_str = str(row.id)
		var card = map_row_to_card(row)
		cards.append(card)
		if not card_cache.has(id_str):
			card_cache[id_str] = card
			card_cache_timestamps[id_str] = Time.get_unix_time_from_system()

	emit_signal("cards_loaded", cards)
	return cards

## Load balance check view → emit Array → return
func run_balance_check() -> Array:
	var sql := """
	SELECT * FROM balance_check ORDER BY status DESC, faction, rank_cost
	"""
	var result = query(sql, [])

	var rows: Array = []
	if result.has("rows"):
		for row in result.rows:
			rows.append({
				"id": row.id,
				"name": row.name,
				"faction": row.faction,
				"rank_cost": row.rank_cost,
				"power": row.power,
				"hard_cap": row.hard_cap,
				"status": row.status
			})

	emit_signal("balance_check_complete", rows)
	return rows

## Validate deck against construction rules → emit result → return
func validate_deck(deck_cards: Array) -> Dictionary:
	var sql := """
	WITH deck AS (
	 SELECT 
	 c.id, c.name, c.card_type, c.faction_id, c.is_unique, c.copy_limit,
	 COUNT(*) as copies
	 FROM unnest($1::int[]) AS card_id
	 JOIN cards c ON c.id = card_id
	 GROUP BY c.id
	)
	SELECT
	 COUNT(*) = 50 AS total_ok,
	 COUNT(DISTINCT faction_id) = 1 AS faction_ok,
	 COUNT(DISTINCT 
	 CASE WHEN card_type NOT IN ('Rift', 'Augment') THEN faction_id END 
	 ) = 1 AS standard_faction_ok,
	 
	 NOT EXISTS (
	 SELECT 1 FROM deck
	 WHERE card_type = 'Rift' AND copies > 1 LIMIT 1
	 ) AS max_one_rift,
	 
	 NOT EXISTS (
	 SELECT 1 FROM deck
	 WHERE card_type = 'Augment' AND copies > 3 LIMIT 1
	 ) AS max_three_augment,
	 
	 NOT EXISTS (
	 SELECT 1 FROM deck
	 WHERE copies > CASE WHEN is_unique THEN 1 ELSE 3 END LIMIT 1
	 ) AS copy_limit_ok,
	 
	 EXISTS (
	 SELECT 1 FROM deck
	 JOIN cards c ON deck.id = c.id
	 WHERE c.is_general_eligible AND c.rank_cost = 1 LIMIT 1
	 ) AS has_general,
	 
	 NOT EXISTS (
	 SELECT 1 FROM deck
	 WHERE card_type = 'Rift'
	 GROUP BY TRUE HAVING COUNT(*) > 3 LIMIT 1
	 ) AS max_three_rifts,
	 
	 EXISTS (
	 SELECT 1 FROM deck
	 WHERE card_type = 'Unit' AND rank_cost = 1 LIMIT 1
	 ) AS has_rank_one_unit
	"""

	var result = query(sql, [deck_cards])
	if not result.has("rows") or result.rows.size() != 1:
		return {"valid": false, "errors": ["No validation result returned"]}

	var errors: Array = []
	var row = result.rows[0]

	if not row.total_ok:
		errors.append("Deck must have exactly 50 cards")
	if not row.faction_ok:
		errors.append("All cards must be from same faction")
	if not row.standard_faction_ok:
		errors.append("All non-Rift/Augment cards must be same faction")
	if not row.max_one_rift:
		errors.append("Max 1 copy of any Rift card")
	if not row.max_three_augment:
		errors.append("Max 3 copies of any Augment card")
	if not row.copy_limit_ok:
		errors.append("Max copies: 1 Unique / 3 Standard")
	if not row.has_general:
		errors.append("Must have at least one Rank 1 General-eligible unit")
	if not row.max_three_rifts:
		errors.append("Max 3 Rift cards")
	if not row.has_rank_one_unit:
		errors.append("Must have at least one Rank 1 Unit")

	var deck_id = deck_cards.join(",")
	emit_signal("deck_validated", deck_id, errors.size() == 0, errors)
	return {"valid": errors.size() == 0, "errors": errors}

## Load faction power tendencies → Dict
func get_faction_power_identity(faction_name: String) -> Dictionary:
	var sql := """
	SELECT power_tendency, ability_tendency FROM factions WHERE name = $1
	"""
	var result = query(sql, [faction_name])
	if result.has("rows") and result.rows.size() > 0:
		return result.rows[0]
	return {"power_tendency": "unknown", "ability_tendency": "unknown"}

## Get power caps by rank → Dict
func get_power_cap(rank: int) -> Dictionary:
	var sql := """
	SELECT * FROM power_caps WHERE rank = $1
	"""
	var result = query(sql, [rank])
	if result.has("rows") and result.rows.size() > 0:
		return result.rows[0]
	return {
		"rank": rank,
		"baseline": 0,
		"range_min": 0,
		"range_max": 0,
		"hard_cap": 0,
		"general_power": 0
	}
#endregion

#region SIGNAL HANDLERS
## Listens to TurnManager.turn_started(player)
func _on_turn_started(player: int) -> void:
	pass ## TODO: load active deck_id
#endregion