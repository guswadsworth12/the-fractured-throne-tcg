class_name AugmentCard
extends res://src/cards/card_data.gd

@export var augment_subtype: String = "Relic"
@export var effect_text: String = ""
@export var host_card_id: int = -1
@export var is_attached: bool = false
@export var goes_to_original_owner_on_destroy: bool = true

func is_weapon() -> bool:
	return augment_subtype == "Weapon"

func is_armor() -> bool:
	return augment_subtype == "Armor"

func is_relic() -> bool:
	return augment_subtype == "Relic"

func attach_to(host_id: int) -> void:
	host_card_id = host_id
	is_attached = true

func detach() -> void:
	host_card_id = -1
	is_attached = false

func from_dict(row: Dictionary) -> AugmentCard:
	super.from_dict(row)
	augment_subtype = row.get("augment_subtype", "Relic")
	effect_text = row.get("effect_text", "")
	host_card_id = -1
	is_attached = false
	goes_to_original_owner_on_destroy = true
	return self