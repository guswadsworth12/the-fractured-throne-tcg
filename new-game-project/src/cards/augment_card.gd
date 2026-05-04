## AugmentCard.gd
## Represents an Augment card (Unit modifiers).
extends "res://src/cards/card_data.gd"

class_name AugmentCard

@export var augment_subtype: String = "" ## "Artifact", "Enchantment", "Equipment"
@export var effect_text: String = ""

func _init() -> void:
	card_type = "Augment"