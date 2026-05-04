## CardData definitions for The Fracture Throne TCG.
## Shared by all managers — loaded via ResourceLoader at runtime.

var id: String = ""
var name: String = ""
var rank: int = 0
var faction_name: String = ""
var power: int = 0
var keywords: Array = []
var is_face_up: bool = false
var card_type: String = "Unit"
var rank_cost: int = 0
var is_unique: bool = false
var copy_limit: int = 3
var flavor_text: String = ""
var set_code: String = "SET1"
var art_path: String = ""
var unit_subtype: String = ""
var frontline_ability: String = ""
var backline_ability: String = ""
var command_ability: String = ""
var is_general_eligible: bool = false
var burst_subtype: String = ""
var effect_text: String = ""
var augment_subtype: String = ""

func _init() -> void:
	pass

func has_keyword(kw: String) -> bool:
	return kw in keywords

func get_allowed_zones() -> Array:
	match card_type:
		"Unit":
			if unit_subtype == "General":
				return ["command_zone"]
			return ["frontline", "backline"]
		"Augment":
			return []
		"Burst":
			return []
		"Rift":
			return ["command_zone"]
	return []

func counts_against_zone_limit(zone: String) -> bool:
	match card_type:
		"Unit":
			match zone:
				"frontline":
					return unit_subtype != "General"
				"backline":
					return unit_subtype != "General" and frontline_ability == ""
				"command_zone":
					return unit_subtype == "General"
		"Burst", "Augment":
			return false
		"Rift":
			return zone == "command_zone"
	return false