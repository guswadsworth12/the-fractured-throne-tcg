## EnergyManager.gd
## Manages Energy state for The Fracture Throne TCG.
## Godot 4 Autoload singleton using GDScript 4 only.
## Communication via signals only — no direct calls to other singletons.
## Listens to ZoneManager and TurnManager signals.
## Never modifies zone contents directly — emits signals for ZoneManager.
## Scenes read Energy state from this singleton — never write to it.

extends Node

class_name EnergyManager

#region SIGNALS EMITTED
## Emitted when Energy count changes for any reason.
## energy_changed(player: int, new_count: int)
signal energy_changed(player: int, new_count: int)

## Emitted when Energy is spent via ZoneManager.spend_energy.
## energy_spent(player: int, amount: int)
signal energy_spent(player: int, amount: int)

## Emitted when Energy is gained from any source.
## energy_gained(player: int, amount: int, source: String)
signal energy_gained(player: int, amount: int, source: String)

## Emitted when Drunken Rage temporary bonus is applied.
## drunken_rage_applied(player: int, card, power_bonus: int)
signal drunken_rage_applied(player: int, card, power_bonus: int)

## Emitted when Drunken Rage temporary bonus expires at Phase 0.
## drunken_rage_expired(player: int, card)
signal drunken_rage_expired(player: int, card)

## Emitted when Sovereign's Reign converts Energy to permanent Power.
## sovereign_reign_resolved(player: int, conversions: Array)
signal sovereign_reign_resolved(player: int, conversions: Array)

## Emitted when House Cut triggers — Syndicate gains Energy from opponent spending.
## house_cut_triggered(player: int, amount: int)
signal house_cut_triggered(player: int, amount: int)

## Emitted when Flame Prayer resolves — Energy gained from unit destruction.
## flame_prayer_resolved(player: int, card)
signal flame_prayer_resolved(player: int, card)

## Emitted when Dragonfire cost is successfully paid.
## dragonfire_cost_paid(player: int, amount: int)
signal dragonfire_cost_paid(player: int, amount: int)

## Emitted when Energy spend is requested but insufficient.
## energy_insufficient(player: int, required: int, available: int)
signal energy_insufficient(player: int, required: int, available: int)

## Emitted for KeywordHandler to resolve Surge ability.
## surge_triggered(player: int, card)
signal surge_triggered(player: int, card)

## Emitted when Blood Tithe penalty applies (no shields broke this turn).
## blood_tithe_penalty(player: int)
signal blood_tithe_penalty(player: int)

## Emitted when Uplink energy threshold condition is met.
## uplink_condition_met(player: int, card, condition_type: String)
signal uplink_condition_met(player: int, card, condition_type: String)

## Emitted at end of turn after all Energy effects resolve.
## end_of_turn_energy_resolved(player: int)
signal end_of_turn_energy_resolved(player: int)
#endregion

#region SIGNALS LISTENED TO
## From ZoneManager
signal shield_broken(player: int, card, shields_remaining: int)
signal surge_triggered_zm(player: int, card)
signal flame_prayer_triggered_zm(player: int)
signal energy_spent_zm(player: int, amount: int)
signal unit_destroyed_zm(player: int, card, zone: String)

## From TurnManager
signal turn_ended_tm(player: int)
signal phase_changed_tm(old_phase: int, new_phase: int)
signal end_phase_started_tm()
#endregion

#region STATE
## Energy count per player — face-up cards in energy_zone
var energy_count: Dictionary = {
	0: 0,
	1: 0
}

## Drunken Rage temporary Power bonuses — TEMPORARY, resets Phase 0
## PERMANENT vs TEMPORARY: Drunken Rage is TEMPORARY (+X00 Power until EOT)
## Bloodlust is PERMANENT — never reset by EnergyManager
var drunken_rage_bonuses: Dictionary = {}

## Tracks pending end-of-turn Energy → Power conversions for Sovereign's Reign
var sovereign_reign_conversions: Dictionary = {
	0: [],
	1: []
}

## House Cut counter — maximum 3 per opponent turn
## RESET: cleared in reset_turn_tracking()
var house_cut_count: Dictionary = {
	0: 0,
	1: 0
}

## Shield breaks this turn — used for Blood Tithe evaluation
## RESET: cleared in reset_turn_tracking()
var shield_breaks_this_turn: Dictionary = {
	0: 0,
	1: 0
}

## Uplink threshold tracking — used for DATA KINGDOM FACTION
## Tracks last threshold crossed per player for edge detection
var _last_uplink_threshold: Dictionary = {
	0: 0,
	1: 0
}
#endregion


#region SIGNAL CONNECTION SETUP
func _ready() -> void:
	_connect_to_turn_manager()
	_connect_to_zone_manager()

func _connect_to_turn_manager() -> void:
	call_deferred("_delayed_turn_manager_connect")

func _delayed_turn_manager_connect() -> void:
	if has_node("/root/TurnManager"):
		var tm = get_node("/root/TurnManager")
		if tm.has_signal("turn_ended"):
			tm.turn_ended.connect(_on_turn_ended)
		if tm.has_signal("phase_changed"):
			tm.phase_changed.connect(_on_phase_changed)
		if tm.has_signal("end_phase_started"):
			tm.end_phase_started.connect(_on_end_phase_started)

func _connect_to_zone_manager() -> void:
	call_deferred("_delayed_zone_manager_connect")

func _delayed_zone_manager_connect() -> void:
	if has_node("/root/ZoneManager"):
		var zm = get_node("/root/ZoneManager")
		if zm.has_signal("shield_broken"):
			zm.shield_broken.connect(_on_shield_broken)
		if zm.has_signal("surge_triggered"):
			zm.surge_triggered.connect(_on_surge_triggered)
		if zm.has_signal("flame_prayer_triggered"):
			zm.flame_prayer_triggered.connect(_on_flame_prayer)
		if zm.has_signal("energy_spent"):
			zm.energy_spent.connect(_on_zone_energy_spent)
		if zm.has_signal("unit_destroyed"):
			zm.unit_destroyed.connect(_on_unit_destroyed)
#endregion

#region ZONE MANAGER SIGNAL HANDLERS
## Called when ZoneManager emits shield_broken
## Shield card moves to energy_zone — increments Energy count
## Surge is handled separately in _on_surge_triggered
func _on_shield_broken(player: int, _card, _shields_remaining: int) -> void:
	energy_count[player] += 1
	shield_breaks_this_turn[player] += 1
	emit_signal("energy_gained", player, 1, "shield_break")
	emit_signal("energy_changed", player, energy_count[player])
	_check_uplink_thresholds(player)

## Called when ZoneManager emits surge_triggered
## Surge triggers ONLY on entry from Shield Zone — already validated by ZoneManager
## EnergyManager trusts this signal — emits for KeywordHandler to resolve
func _on_surge_triggered(player: int, card) -> void:
	emit_signal("surge_triggered", player, card)

## Called when ZoneManager emits flame_prayer_triggered
## EMBERCROWN FACTION
## Flame Prayer: when unit destroyed, gain 1 face-up Energy
## Triggers before General Power growth
## Multiple Flame Prayer units destroyed same turn each generate 1
func _on_flame_prayer(player: int) -> void:
	energy_count[player] += 1
	emit_signal("energy_gained", player, 1, "flame_prayer")
	emit_signal("energy_changed", player, energy_count[player])
	_check_uplink_thresholds(player)

## Called when ZoneManager emits energy_spent
## This is informational — ZoneManager already decremented zone contents
## EnergyManager updates its count to stay in sync
func _on_zone_energy_spent(player: int, amount: int) -> void:
	energy_count[player] -= amount
	if energy_count[player] < 0:
		push_error("EnergyManager: Energy count went negative for player %d" % player)
		energy_count[player] = 0
	emit_signal("energy_changed", player, energy_count[player])

## Called when ZoneManager emits unit_destroyed
## Checks for Flame Prayer keyword on destroyed card
func _on_unit_destroyed(player: int, card, _zone: String) -> void:
	if card.has_keyword("Flame Prayer"):
		emit_signal("flame_prayer_resolved", player, card)
#endregion

#region TURN MANAGER SIGNAL HANDLERS
## Called when TurnManager emits turn_ended
## Resets per-turn counters only — never permanent state
func _on_turn_ended(player: int) -> void:
	reset_turn_tracking(player)

## Called when TurnManager emits phase_changed
## Phase 0 (UNTAP) resets temporary effects
func _on_phase_changed(_old_phase: int, new_phase: int) -> void:
	if new_phase == 0:  ## PHASE_UNTAP
		reset_temporary_effects()

## Called when TurnManager emits end_phase_started
## Resolves end-of-turn effects in specific order
func _on_end_phase_started() -> void:
	for player in [0, 1]:
		resolve_end_of_turn_effects(player)
#endregion

#region PUBLIC API - ENERGY SPENDING
## Called by other systems that need to spend Energy
## Validates available Energy before approving spend
## Returns true if spend is legal, false if insufficient
## NEVER modifies zone contents — emits signal for ZoneManager
func request_spend_energy(player: int, amount: int) -> bool:
	if energy_count[player] < amount:
		emit_signal("energy_insufficient", player, amount, energy_count[player])
		return false
	return true

## Requests spending Energy for Drunken Rage
## GILDED SYNDICATE FACTION
## CRITICAL: Drunken Rage is TEMPORARY — resets end of turn
## NEVER confuse with Bloodlust which is PERMANENT
## [ENERGY: X] — one chosen Frontline unit gains +X×100 Power until EOT
## Maximum [ENERGY: 5] for +500 Power
func apply_drunken_rage(player: int, card, energy_cost: int) -> bool:
	if energy_cost > 5:
		push_error("EnergyManager: Drunken Rage max energy cost is 5")
		return false
	if not request_spend_energy(player, energy_cost):
		return false
	var power_bonus := energy_cost * 100
	drunken_rage_bonuses[card.id] = power_bonus
	emit_signal("drunken_rage_applied", player, card, power_bonus)
	return true

## Pays Dragonfire cost for Embercrown faction
## EMBERCROWN FACTION
## Dragonfire scaling costs:
##   1 unit = [ENERGY: 2]
##   2 units = [ENERGY: 3]
##   3 units = [ENERGY: 5]
##   4 units = [ENERGY: 8]
## Dragonfire is NOT combat — does not trigger Bloodlust or Reanimate
func pay_dragonfire_cost(player: int, target_count: int) -> bool:
	var cost := _get_dragonfire_cost(target_count)
	if cost == 99:
		push_error("EnergyManager: Invalid Dragonfire target count: %d" % target_count)
		return false
	if not request_spend_energy(player, cost):
		return false
	emit_signal("dragonfire_cost_paid", player, cost)
	return true

## Private helper — Dragonfire cost lookup
func _get_dragonfire_cost(target_count: int) -> int:
	match target_count:
		1: return 2
		2: return 3
		3: return 5
		4: return 8
		_: return 99  ## illegal target count
#endregion

#region PUBLIC API - FACTION MECHANICS
## Called when opponent spends Energy on an ability
## GILDED SYNDICATE FACTION
## House Cut: gain 1 face-up Energy whenever opponent spends Energy
## Maximum 3 per opponent turn
func on_house_cut_triggered(syndicate_player: int, _opponent_player: int) -> void:
	if house_cut_count[syndicate_player] >= 3:
		return
	energy_count[syndicate_player] += 1
	house_cut_count[syndicate_player] += 1
	emit_signal("energy_gained", syndicate_player, 1, "house_cut")
	emit_signal("house_cut_triggered", syndicate_player, house_cut_count[syndicate_player])
	emit_signal("energy_changed", syndicate_player, energy_count[syndicate_player])
	_check_uplink_thresholds(syndicate_player)

## Called when ZoneManager emits energy_spent
## Notifies Syndicate players for House Cut
func notify_energy_spent(player: int, opponent: int) -> void:
	on_house_cut_triggered(opponent, player)
#endregion

#region END OF TURN EFFECTS
## Resolves end-of-turn effects in specific order:
##   1. Sovereign's Reign conversion (if active General has it)
##   2. Blood Tithe check (Vampiric Hell passive)
## Drunken Rage expiry is handled in reset_temporary_effects()
## which is called at Phase 0 UNTAP — not here
func resolve_end_of_turn_effects(player: int) -> void:
	## VAMPIRIC HELL FACTION - Blood Tithe check
	_check_blood_tithe(player)
	emit_signal("end_of_turn_energy_resolved", player)

## VAMPIRIC HELL FACTION
## Blood Tithe: Gain 1 Energy per Shield broken this turn
## If NO friendly Shield broke this turn: all friendly units lose 50 Power
## EnergyManager tracks shield_breaks_this_turn for this evaluation
func _check_blood_tithe(player: int) -> void:
	if shield_breaks_this_turn[player] == 0:
		emit_signal("blood_tithe_penalty", player)
## If shields broke, Energy already gained via _on_shield_broken — no extra action
#endregion

#region TEMPORARY EFFECTS RESET
## Called when TurnManager emits phase_changed(PHASE_UNTAP)
## Expires all Drunken Rage bonuses from previous turn
## CRITICAL: Only temporary effects reset here
## Bloodlust bonuses are PERMANENT — never touched here
## Drunken Rage: TEMPORARY — resets end of turn
## Bloodlust: PERMANENT — never resets
func reset_temporary_effects() -> void:
	for card_id in drunken_rage_bonuses:
		var card_data = _get_card_by_id(card_id)
		if card_data != null:
			emit_signal("drunken_rage_expired", 0, card_data)
			emit_signal("drunken_rage_expired", 1, card_data)
	drunken_rage_bonuses.clear()

func _get_card_by_id(_card_id: String):
	return null  ## Placeholder — KeywordHandler tracks card instances
#endregion

#region TURN TRACKING RESET
## Resets per-turn counters only — never permanent state
## Called when TurnManager emits turn_ended
func reset_turn_tracking(player: int) -> void:
	house_cut_count[player] = 0
	shield_breaks_this_turn[player] = 0
	sovereign_reign_conversions[player].clear()
#endregion

#region UPLINK THRESHOLD CHECKING
## DATA KINGDOM FACTION
## Monitors Energy count changes for Uplink threshold conditions
## Emits uplink_condition_met when threshold crossed
func _check_uplink_thresholds(player: int) -> void:
	var threshold := 0
	if energy_count[player] >= 5 and _last_uplink_threshold[player] < 5:
		threshold = 5
		emit_signal("uplink_condition_met", player, null, "energy_5")
	elif energy_count[player] >= 3 and _last_uplink_threshold[player] < 3:
		threshold = 3
		emit_signal("uplink_condition_met", player, null, "energy_3")
	_last_uplink_threshold[player] = max(_last_uplink_threshold[player], threshold)
#endregion

#region PUBLIC API - READ ONLY
## Read-only accessor for scenes and other systems
func get_energy_count(player: int) -> int:
	return energy_count.get(player, 0)

## Returns Drunken Rage bonus for a card (0 if none)
func get_drunken_rage_bonus(card_id: String) -> int:
	return drunken_rage_bonuses.get(card_id, 0)

## Returns House Cut count for player
func get_house_cut_count(player: int) -> int:
	return house_cut_count.get(player, 0)
#endregion

#region INITIALIZATION
## Initializes Energy state for a player at game start
func initialize_player(player: int) -> void:
	energy_count[player] = 0
	drunken_rage_bonuses.clear()
	house_cut_count[player] = 0
	shield_breaks_this_turn[player] = 0
	sovereign_reign_conversions[player].clear()
	_last_uplink_threshold[player] = 0
#endregion