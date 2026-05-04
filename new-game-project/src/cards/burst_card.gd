class_name BurstCard
extends res://src/cards/card_data.gd

@export var burst_subtype: String = "Cast"
@export var effect_text: String = ""
@export var trigger_condition: String = ""

func is_reaction() -> bool:
	return burst_subtype == "Reaction"

func is_cast() -> bool:
	return burst_subtype == "Cast"

func from_dict(row: Dictionary) -> BurstCard:
	super.from_dict(row)
	burst_subtype = row.get("burst_subtype", "Cast")
	effect_text = row.get("effect_text", "")
	trigger_condition = ""
	return self