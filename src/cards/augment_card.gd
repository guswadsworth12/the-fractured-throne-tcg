class_name AugmentCard
extends Card

# TODO: Augment cards — modify a unit's stats or grant keywords
# Attached to a unit, separated on unit destruction

var modifier: Dictionary = {}
var attached_unit: Object = null

func _init() -> void:
	card_type = "augment"
	super._init()

func attach_to(unit: Object) -> void:
	# TODO: Attach augment to unit, apply modifier
	pass

func detach() -> void:
	# TODO: Remove augment from unit, reverse modifier
	pass

func get_attached_unit() -> Object:
	return attached_unit