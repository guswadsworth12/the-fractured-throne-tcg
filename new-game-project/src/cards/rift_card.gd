## RiftCard.gd
## Represents a Rift card (Global battlefield effects).
extends "res://src/cards/card_data.gd"

class_name RiftCard

@export var effect_text: String = ""

func _init() -> void:
	card_type = "Rift"