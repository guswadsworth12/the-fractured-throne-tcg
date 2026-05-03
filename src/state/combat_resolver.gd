class_name CombatResolver
extends Node

# Resolves attacks: Power comparison, Shield breaks, Bloodlust, Drunken Rage, Void Pulse, Dragonfire
# Turn phases 5a (backline) and 5b (frontline)

signal combat_resolved(attacker: Object, defender: Object, result: Dictionary)

func _ready() -> void:
	pass

func resolve_attack(attacker: Object, defender: Object, is_frontline: bool = true) -> Dictionary:
	# TODO:
	# - Compare attacker Power vs defender Power (or Shield)
	# - Apply Bloodlust (permanent) on kill
	# - Apply Drunken Rage (resets end of turn)
	# - Apply Void Pulse (resets start of opponent's next turn)
	# - Dragonfire does NOT trigger Bloodlust or Reanimate
	# - Return result dict: {damage_dealt, damage_taken, attacker_destroyed, defender_destroyed, shield_broken}
	return {}

func calculate_power(unit: Object, for_attack: bool = false) -> int:
	# TODO: Compute effective Power with all temporary modifiers applied
	return 0

func apply_bloodlust(unit: Object, power_bonus: int) -> void:
	# TODO: Permanent Power increase — never resets
	pass

func apply_drunken_rage(unit: Object, power_bonus: int) -> void:
	# TODO: Temporary Power increase — resets end of turn
	pass

func apply_void_pulse(unit: Object, power_penalty: int) -> void:
	# TODO: Temporary Power reduction — resets start of opponent's next turn
	pass

func resolve_shield_breaks(attacker: Object, defender: Object, shield_count: int) -> void:
	# TODO: Handle Pierce (extra break), Lifesteal (move Energy)
	pass