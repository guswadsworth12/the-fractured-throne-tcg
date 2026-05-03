class_name RiftCard
extends Card

# TODO: Rift cards — 1 max in rift_zone, shared between both players
# Global battlefield effect, not attached to any player

var rift_ability: String = ""
var is_active: bool = false

func _init() -> void:
	card_type = "rift"
	super._init()

func activate() -> void:
	# TODO: Activate rift effect
	pass

func deactivate() -> void:
	# TODO: Deactivate rift effect
	pass

func is_global() -> bool:
	return true