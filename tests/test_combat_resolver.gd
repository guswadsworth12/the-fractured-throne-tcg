extends Node

# TODO: Test combat resolution — Power comparison, Bloodlust, Drunken Rage,
# Void Pulse, Shield breaks, Dragonfire

func _ready() -> void:
	pass

func test_bloodlust_permanent() -> void:
	# Bloodlust must be permanent — verify it never resets
	pass

func test_drunken_rage_resets() -> void:
	# Drunken Rage must reset end of turn
	pass

func test_void_pulse_timing() -> void:
	# Void Pulse resets start of opponent's next turn
	pass

func test_power_ranking() -> void:
	# Higher Power wins combat; ties go to defender
	pass

func test_shield_breaks() -> void:
	# Shield breaks from combat resolved through CombatResolver
	pass

func test_dragonfire_no_bloodlust() -> void:
	# Dragonfire does NOT trigger Bloodlust or Reanimate
	pass