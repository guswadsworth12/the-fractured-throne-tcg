class_name BurstCard
extends Card

# TODO: Burst cards — instant effects, resolved immediately
# Cannot target Aegis units. Do not trigger combat (no Bloodlust, no Reanimate).

var target_type: String = ""
var effect: Dictionary = {}

func _init() -> void:
	card_type = "burst"
	super._init()

func resolve(source: Object, targets: Array) -> Dictionary:
	# TODO: Execute burst effect, return result
	return {}

func is_valid_target(target: Object) -> bool:
	return true

func can_target_aegis() -> bool:
	return false