class_name KeywordHandler
extends Node

# TODO: Resolves keyword effect triggers (Bloodlust, Drunken Rage, Void Pulse,
# Sovereign's Reign, Legacy, Surge, Reanimate, Dragonfire, Blitz, etc.)

func _ready() -> void:
	pass

func resolve_keyword(keyword: String, context: Dictionary) -> Dictionary:
	# TODO: Dispatch to specific keyword resolver
	return {}

func resolve_bloodlust(killer: Object, killed: Object) -> void:
	# PERMANENT power increase on kill — never resets
	pass

func resolve_drunken_rage(unit: Object, bonus: int) -> void:
	# TEMPORARY — resets end of turn
	pass

func resolve_void_pulse(unit: Object, penalty: int) -> void:
	# TEMPORARY — resets start of opponent's next turn
	pass

func resolve_sovereigns_reign(unit: Object, energy_spent: int) -> void:
	# PERMANENT power from energy conversion at end of turn
	pass

func resolve_legacy(unit: Object) -> bool:
	# Command abilities ONLY — not Frontline or Backline
	return false

func resolve_surge(card: Object) -> void:
	# Triggers ONLY entering Energy Zone from Shield Zone
	pass

func resolve_reanimate(unit: Object) -> void:
	# Triggers on destruction — can be permanently removed
	pass

func resolve_dragonfire(target: Object, damage: int) -> void:
	# Non-combat — does NOT trigger Bloodlust or Reanimate
	pass

func resolve_blitz(unit: Object, granted: bool) -> void:
	# Grants temporary Blitz (ignores Summon Delay)
	pass