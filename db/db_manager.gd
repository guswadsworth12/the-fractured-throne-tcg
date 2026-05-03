class_name DbManager
extends Node

# TODO: Postgres connection via pg_client plugin
# Connection params: database=fracture_throne, user=rend (local socket)

var _connection: Object = null

func _ready() -> void:
	pass

func query(sql: String) -> Array:
	# TODO: Execute SQL query and return array of rows
	return []

func fetch_card_by_id(card_id: int) -> Dictionary:
	# TODO: SELECT * FROM cards WHERE id = $1
	return {}

func fetch_balance_check(card_id: int) -> Dictionary:
	# TODO: SELECT * FROM balance_check WHERE card_id = $1
	return {}