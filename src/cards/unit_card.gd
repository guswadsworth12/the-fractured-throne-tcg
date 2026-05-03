class_name UnitCard
extends Card

# TODO: Unit cards — have Power, Rank, and zone placement
# Subtypes: Infantry, Cavalry, General (command_zone only)
# Balance: Rank 1-4, Power 200-1300, General hard cap 1000

var power: int = 0
var rank: int = 1
var unit_type: String = ""
var frontline_ability: String = ""
var backline_ability: String = ""
var command_ability: String = ""
var summon_delay: bool = false
var base_power: int = 0

func _init() -> void:
	card_type = "unit"
	super._init()

func get_effective_power() -> int:
	return power

func get_rank() -> int:
	return rank

func can_attack() -> bool:
	return not summon_delay

func has_summon_delay() -> bool:
	return summon_delay

func apply_bloodlust(amount: int) -> void:
	# TODO: Permanent +amount to power
	pass

func apply_drunken_rage(amount: int) -> void:
	# TODO: Temporary +amount to power, resets end of turn
	pass

func apply_void_pulse(amount: int) -> void:
	# TODO: Temporary -amount to power, resets start of opponent next turn
	pass