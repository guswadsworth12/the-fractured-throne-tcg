class_name Card
extends Resource

# TODO: Base card class — all card types extend this
# Card data loaded from Postgres cards table

var card_id: int = 0
var name: String = ""
var faction_id: int = 0
var card_type: String = ""
var cost: int = 0
var keywords: Array = []
var rules_text: String = ""

func _init() -> void:
	pass

func get_display_name() -> String:
	return name

func get_keywords() -> Array:
	return keywords

func has_keyword(kw: String) -> bool:
	return kw in keywords