## BurstCard.gd
## Represents a Burst card (Instant effects).
extends "res://src/cards/card_data.gd"

class_name BurstCard

@export var burst_subtype: String = "" ## "Reaction", "Fast", "Slow"
@export var effect_text: String = ""

func _init() -> void:
	card_type = "Burst"