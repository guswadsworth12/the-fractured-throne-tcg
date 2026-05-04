## CardData.gd
## Base card data resource for The Fracture Throne TCG.
## All card types (Unit, Burst, Augment, Rift) extend this class.
extends Resource

class_name CardData

#region SHARED FIELDS
@export var id: int = 0
@export var name: String = ""
@export var faction_name: String = ""
@export var card_type: String = "" ## "Unit", "Burst", "Augment", "Rift"
@export var rank_cost: int = 0
@export var is_unique: bool = false
@export var copy_limit: int = 3
@export var keywords: Array = [] ## Array[String]
@export var flavor_text: String = ""
@export var set_code: String = "SET1"
@export var art_path: String = ""
#endregion

func _init() -> void:
	pass

func has_keyword(kw: String) -> bool:
	return kw in keywords

func get_display_name() -> String:
	return name