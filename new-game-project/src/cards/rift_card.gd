class_name RiftCard
extends res://src/cards/card_data.gd

@export var effect_text: String = ""
@export var is_end_of_turn_effect: bool = false
@export var affects_both_players: bool = true

func from_dict(row: Dictionary) -> RiftCard:
	super.from_dict(row)
	effect_text = row.get("effect_text", "")
	affects_both_players = true
	is_end_of_turn_effect = effect_text.to_lower().contains("end of turn")
	return self