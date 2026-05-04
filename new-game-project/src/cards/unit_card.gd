## UnitCard.gd
## Represents a Unit card (Infantry, Cavalry, General).
extends "res://src/cards/card_data.gd"

class_name UnitCard

@export var power: int = 0
@export var unit_subtype: String = "" ## "General", "Frontline", "Backline", ""
@export var frontline_ability: String = ""
@export var backline_ability: String = ""
@export var command_ability: String = ""
@export var is_general_eligible: bool = false
@export var summon_delay: bool = true

func _init() -> void:
	card_type = "Unit"