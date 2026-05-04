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
## - card_loaded(card)
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
signal card_loaded(card)
signal cards_loaded(cards: Array)
signal deck_validated(deck_id: String, is_valid: bool, errors: Array)
signal balance_check_complete(results: Array)
signal faction_data_loaded(faction_id: int, data: Dictionary)
signal query_failed(query_type: String, error: String)
#endregion

#region STATE
var http_client: HTTPClient = HTTPClient.new()
const BASE_URL := "http://localhost:8000"
var is_connected: bool = false
var card_cache: Dictionary = {}
var card_cache_timestamps: Dictionary = {}
var faction_cache: Dictionary = {}
var keyword_cache: Dictionary = {}
var pending_requests: Array = []
const CACHE_MAX_AGE := 300
#endregion

#region INITIALIZATION
func _ready() -> void:
	check_connection()
	_setup_signal_connections()

func _setup_signal_connections() -> void:
	call_deferred("_deferred_signal_connections")

func _deferred_signal_connections() -> void:
	if not has_node("/root/TurnManager"):
		return
	var tm = get_node("/root/TurnManager")
	tm.connect("turn_started", Callable(self, "_on_turn_started"), CONNECT_DEFERRED)
#endregion

#region CONNECTION
func check_connection() -> void:
	http_client.connect_to_host(BASE_URL)
	var result = http_client.request(HTTPClient.METHOD_GET, "/health",
		["User-Agent: Godot/4.0", "Accept: application/json"])
	if result != OK:
		set_connection_failure("Could not connect to bridge")
		return

func set_connection_failure(prefix: String) -> void:
	var msg = prefix + ". Start bridge.py first:\n"
	var cmd = "cd /home/rend/Projects/the-fractured-throne-tcg/db\nbash start_bridge.sh"
	is_connected = false
	emit_signal("db_connection_failed", msg + cmd)
#endregion

#region HTTP HELPERS
func _poll_response() -> int:
	var status = http_client.get_status()
	while status == HTTPClient.STATUS_REQUESTING:
		http_client.poll()
		OS.delay_msec(10)
		status = http_client.get_status()
	return status

func _read_body() -> String:
	var chunks = []
	while http_client.get_status() == HTTPClient.STATUS_BODY:
		http_client.poll()
		var chunk = http_client.read_response_body_chunk()
		if chunk.size() > 0:
			chunks.append(chunk.get_string_from_utf8())
	return "".join(chunks)
#endregion

#region CORE QUERY
func query(sql_cmd: String, params: Array = []) -> Dictionary:
	if http_client.get_status() != HTTPClient.STATUS_BODY:
		emit_signal("query_failed", "query", "Not connected")
		return {}

	var body = JSON.stringify({"sql": sql_cmd, "params": params})
	var headers = [
		"Content-Type: application/json",
		"Content-Length: " + str(body.length())
	]
	var result = http_client.request(HTTPClient.METHOD_POST, "/query", headers, body)
	if result != OK:
		emit_signal("query_failed", "query", "HTTP request failed")
		return {}

	var status = _poll_response()
	if status != HTTPClient.STATUS_BODY:
		emit_signal("query_failed", "query", "HTTP status: %d" % [status])
		return {}

	var body_str = _read_body()
	var json = JSON.new()
	if json.parse(body_str) != OK:
		emit_signal("query_failed", "json", "Parse failed: " + body_str)
		return {}

	var data = json.get_data()
	if typeof(data) != TYPE_DICTIONARY:
		emit_signal("query_failed", "json", "Expected dict, got %d" % [typeof(data)])
		return {}

	if data.has("error"):
		emit_signal("query_failed", "bridge", str(data.error))
		return {}

	is_connected = true
	emit_signal("db_connected")
	return data
#endregion

#region CARD MAPPING
func map_row_to_card(row: Dictionary) : :
	var card = CardData.new()
	card.id = str(row.get("id", ""))
	card.name = row.get("name", "")
	card.faction_name = row.get("faction_name", "")
	card.card_type = row.get("card_type", "Unit")
	card.rank_cost = row.get("rank_cost", 0)
	card.is_unique = row.get("is_unique", false)
	card.copy_limit = row.get("copy_limit", 3)

	var kw_raw = row.get("keywords", [])
	if typeof(kw_raw) == TYPE_STRING:
		var s = kw_raw.strip_edges()
		if s.length() > 0:
			card.keywords = s.split(",").map(func(e): return e.strip())
		else:
			card.keywords = []
	elif typeof(kw_raw) == TYPE_ARRAY:
		card.keywords = kw_raw
	else:
		card.keywords = []

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
#endregion

#region PUBLIC API
func load_card(card_id: int) : :
	var key = str(card_id)
	if card_cache.has(key):
		var ts = card_cache_timestamps.get(key, 0.0)
		if Time.get_unix_time_from_system() - ts < CACHE_MAX_AGE:
			return card_cache[key]

	const SQL = """
		SELECT c.*, f.name as faction_name,
		 array_agg(k.name) as keywords
		FROM cards c
		LEFT JOIN factions f ON c.faction_id = f.id
		LEFT JOIN card_keywords ck ON c.id = ck.card_id
		LEFT JOIN keywords k ON ck.keyword_id = k.id
		WHERE c.id = $1
		GROUP BY c.id, f.name
	"""
	var result = query(SQL, [card_id])
	if not result.has("rows") or result.rows.size() == 0:
		var fallback = CardData.new()
		fallback.id = key
		return fallback

	var card = map_row_to_card(result.rows[0])
	card_cache[key] = card
	card_cache_timestamps[key] = Time.get_unix_time_from_system()
	emit_signal("card_loaded", card)
	return card

func load_faction_cards(faction_name: String) -> Array:
	const SQL = """
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
	var result = query(SQL, [faction_name])
	var cards: Array = []
	if result.has("rows"):
		for row in result.rows:
			var card = map_row_to_card(row)
			cards.append(card)
			var key = str(row.id)
			if not card_cache.has(key):
				card_cache[key] = card
				card_cache_timestamps[key] = Time.get_unix_time_from_system()

	emit_signal("cards_loaded", cards)
	return cards

func run_balance_check() -> Array:
	const SQL = "SELECT * FROM balance_check ORDER BY status DESC, faction, rank_cost"
	var result = query(SQL, [])
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

func validate_deck(deck_cards: Array) -> Dictionary:
	const SQL = """
		WITH deck AS (
		 SELECT c.id, c.name, c.card_type, c.faction_id,
		  c.is_unique, c.copy_limit, COUNT(*) as copies
		 FROM unnest($1::int[]) AS card_id
		 JOIN cards c ON c.id = card_id
		 GROUP BY c.id
		)
		SELECT
		 COUNT(*) = 50 AS total_ok,
		 COUNT(DISTINCT faction_id) = 1 AS faction_ok,
		 NOT EXISTS (SELECT 1 FROM deck WHERE card_type = 'Rift' AND copies > 1 LIMIT 1) AS max_one_rift,
		 NOT EXISTS (SELECT 1 FROM deck WHERE card_type = 'Augment' AND copies > 3 LIMIT 1) AS max_three_augment,
		 NOT EXISTS (SELECT 1 FROM deck WHERE copies > CASE WHEN is_unique THEN 1 ELSE 3 END LIMIT 1) AS copy_limit_ok,
		 EXISTS (SELECT 1 FROM deck JOIN cards c ON deck.id = c.id WHERE c.is_general_eligible AND c.rank_cost = 1 LIMIT 1) AS has_general,
		 NOT EXISTS (SELECT 1 FROM deck WHERE card_type = 'Rift' GROUP BY TRUE HAVING COUNT(*) > 3 LIMIT 1) AS max_three_rifts,
		 EXISTS (SELECT 1 FROM deck WHERE card_type = 'Unit' AND rank_cost = 1 LIMIT 1) AS has_rank_one_unit
	"""
	var result = query(SQL, [deck_cards])
	var errors: Array = []
	if not result.has("rows") or result.rows.size() != 1:
		return {"valid": false, "errors": ["No validation result"]}

	var r = result.rows[0]
	if not r.total_ok: errors.append("Deck must have exactly 50 cards")
	if not r.faction_ok: errors.append("All cards must be same faction")
	if not r.max_one_rift: errors.append("Max 1 copy of any Rift card")
	if not r.max_three_augment: errors.append("Max 3 copies of any Augment card")
	if not r.copy_limit_ok: errors.append("Max copies: 1 Unique / 3 Standard")
	if not r.has_general: errors.append("Must have at least one Rank 1 General-eligible unit")
	if not r.max_three_rifts: errors.append("Max 3 Rift cards total")
	if not r.has_rank_one_unit: errors.append("Must have at least one Rank 1 Unit")

	var is_valid = errors.size() == 0
	emit_signal("deck_validated", "", is_valid, errors)
	return {"valid": is_valid, "errors": errors}

func get_faction_power_identity(faction_name: String) -> Dictionary:
	const SQL = "SELECT power_tendency, ability_tendency FROM factions WHERE name = $1"
	var result = query(SQL, [faction_name])
	if result.has("rows") and result.rows.size() > 0:
		return result.rows[0]
	return {"power_tendency": "unknown", "ability_tendency": "unknown"}

func get_power_cap(rank: int) -> Dictionary:
	const SQL = "SELECT * FROM power_caps WHERE rank = $1"
	var result = query(SQL, [rank])
	if result.has("rows") and result.rows.size() > 0:
		return result.rows[0]
	return {"rank": rank, "baseline": 0, "range_min": 0, "range_max": 0, "hard_cap": 0, "general_power": 0}
#endregion

#region SIGNAL HANDLERS
func _on_turn_started(player: int) -> void:
	pass
#endregion