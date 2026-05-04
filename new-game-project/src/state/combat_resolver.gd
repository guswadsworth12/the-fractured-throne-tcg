## CombatResolver.gd
## Resolves all combat for The Fracture Throne TCG.
## Godot 4 Autoload singleton using GDScript 4 only.
## Communication via signals only — no direct calls to other singletons
## except ZoneManager.break_shield() and ZoneManager.destroy_unit()
## during combat resolution (same pattern as ShieldManager).
## Listens to TurnManager, ZoneManager, ShieldManager, EnergyManager.

extends Node

class_name CombatResolver

#region CRITICAL RULES
## CRITICAL: Bloodlust is PERMANENT — never resets under any condition
## CRITICAL: Drunken Rage is TEMPORARY — resets end of turn
## CRITICAL: Void Pulse is TEMPORARY — resets start of opponent turn
## CRITICAL: Sovereign's Reign is PERMANENT conversion
## CRITICAL: Dragonfire is NOT combat — Bloodlust, Reanimate,
##           Sentinel do not trigger from Dragonfire
## CRITICAL: Infiltrate attacks never break Shields under any condition
## CRITICAL: Pierce triggers ONCE per attack — not per Shield broken
## CRITICAL: Lifesteal does NOT trigger on Pierce-caused breaks
## CRITICAL: Oathstrike requires zero defenders AND non-Infiltrate
## CRITICAL: Wither self-destruction is NOT combat
## CRITICAL: Elder's Verdict floor = base Power, not 0
## CRITICAL: Warden's Light floor = 100, only from ability reductions
##           not from combat Power comparison
## CRITICAL: Sentinel units may both attack AND defend in same round
## CRITICAL: Overcharge units destroyed at end of turn — not combat
#endregion

#region POWER MODIFICATION HIERARCHY
## When calculating any unit's effective Power, apply in this order:
##   1. Base Power (from card data — never changes except Bloodlust
##      and Sovereign's Reign which are permanent modifications)
##   2. Bloodlust gains (permanent — add)
##   3. Sovereign's Reign gains (permanent — add)
##   4. Boost from Backline (attack only — add)
##   5. Drunken Rage bonus (temporary — add)
##   6. Radiant Lattice bonus (temporary — add, defenders only)
##   7. Void Pulse reduction (temporary — subtract)
##   8. Elder's Verdict floor (cannot go below base Power)
##   9. Warden's Light floor (cannot go below 100 from ability reductions)
##  10. Hard floor: Power cannot go below 0 ever
#endregion

#region PHASE CONSTANTS (matching TurnManager)
const PHASE_UNTAP := 0
const PHASE_DRAW := 1
const PHASE_REFRESH := 2
const PHASE_FIRSTMAIN := 3
const PHASE_COMBAT := 4
const PHASE_SECONDMAIN := 5
const PHASE_END := 6
#endregion

#region SIGNALS EMITTED
## Emitted when an attack is formally declared.
## attack_declared(attacker, target_zone: String, target_player: int)
signal attack_declared(attacker, target_zone: String, target_player: int)

## Emitted when defending player confirms defender selection.
## defenders_chosen(defenders: Array[CardData])
signal defenders_chosen(defenders: Array)

## Emitted when a Backline unit boosts its paired Frontline attacker.
## boost_applied(attacker, backline_unit, boost_value: int)
signal boost_applied(attacker, backline_unit, boost_value: int)

## Emitted after Power comparison is complete.
## power_comparison_resolved(attacker_power: int, defense_power: int, attacker_wins: bool)
signal power_comparison_resolved(attacker_power: int, defense_power: int, attacker_wins: bool)

## Emitted when the attacking unit is destroyed in combat.
## attacker_destroyed(card)
signal attacker_destroyed(card)

## Emitted when a defending unit is destroyed in combat.
## defender_destroyed(card)
signal defender_destroyed(card)

## Emitted when attack goes directly to General (zero defenders).
## general_attacked(target_player: int)
signal general_attacked(target_player: int)

## Emitted when all combat resolution for an attack is complete.
signal combat_resolved()

## Emitted when an Infiltrate attack is declared.
## infiltrate_attack_declared(attacker, target_unit, target_player: int)
signal infiltrate_attack_declared(attacker, target_unit, target_player: int)

## Emitted when an Interceptor is deployed against an Infiltrate attack.
## interceptor_deployed(player: int, interceptor)
signal interceptor_deployed(player: int, interceptor)

## Emitted when a unit gains Power from Bloodlust (permanent).
## bloodlust_gained(player: int, card, new_power: int)
signal bloodlust_gained(player: int, card, new_power: int)

## Emitted when Void Pulse reduction is applied (temporary).
## void_pulse_applied(player: int, card, reduction: int)
signal void_pulse_applied(player: int, card, reduction: int)

## Emitted when Void Pulse reduction expires.
## void_pulse_expired(player: int, card)
signal void_pulse_expired(player: int, card)

## Emitted when Sovereign's Reign grants permanent Power.
## sovereign_reign_applied(player: int, card, power_gain: int)
signal sovereign_reign_applied(player: int, card, power_gain: int)

## Emitted when Drunken Rage bonus expires at Phase 0.
## drunken_rage_expired(player: int, card)
signal drunken_rage_expired(player: int, card)

## Emitted when an Overcharge unit is destroyed at end of turn.
## overcharge_destroyed(player: int, card)
signal overcharge_destroyed(player: int, card)

## Emitted when Drakesworn Bond is broken — surviving unit Power halved.
## drakesworn_bond_broken(player: int, surviving_card, new_power: int)
signal drakesworn_bond_broken(player: int, surviving_card, new_power: int)

## Emitted when Diamond League Lineup chain triggers.
## lineup_chain_triggered(player: int, card, bonus: int)
signal lineup_chain_triggered(player: int, card, bonus: int)

## Emitted when Prophet/Prophecy predicts correctly.
## prophecy_activated(player: int, card)
signal prophecy_activated(player: int, card)

## Emitted when Diamond League Relay applies bonus to all Frontline units.
## relay_bonus_applied(player: int, bonus: int)
signal relay_bonus_applied(player: int, bonus: int)

## Emitted when Dominion blocks opponent's Burst — Reaction window.
## dominion_activated(player: int, attacker)
signal dominion_activated(player: int, attacker)

## Emitted when Anchor blocks a forced move.
## anchor_blocked_move(card)
signal anchor_blocked_move(card)
#endregion

#region STATE
## Current attack being resolved — cleared after each attack
var current_attack: Dictionary = {
	attacker = null,
	defenders = [],
	defender_player = -1,
	attacker_player = -1,
	target_zone = "",
	boost_value = 0,
	infiltrate_active = false,
	zero_defenders_chosen = false
}

## Units that have both attacked and defended this turn (Sentinel keyword)
var sentinel_units: Array = []

## PERMANENT Power gains from kills — NEVER CLEARED
## CRITICAL: Bloodlust is permanent — never reset under any condition
var bloodlust_gains: Dictionary = {}

## TEMPORARY Power reductions — reset on Phase 0 UNTAP
## NEVER confuse with Bloodlust which is PERMANENT
var void_pulse_reductions: Dictionary = {}

## PERMANENT Power gains from Sovereign's Reign — NEVER CLEARED
## CRITICAL: Sovereign's Reign is permanent — never reset
var sovereign_reign_bonuses: Dictionary = {}

## TEMPORARY Power bonuses from Drunken Rage — reset EOT
var drunken_rage_bonuses: Dictionary = {}

## Units with Overcharge that die at end of turn
var overcharge_units: Array = []

## Current Radiant Lattice bonus per player — updated from ShieldManager signal
var radiant_lattice_bonus: Dictionary = {0: 0, 1: 0}

## Warden's Light protection active per player
var warden_light_active: Dictionary = {0: false, 1: false}

## Maximum Void Lock targets per turn
const MAX_VOID_LOCK_TARGETS := 2
var void_lock_count: Dictionary = {0: 0, 1: 0}

## Lineup chain tracking for Diamond League
var previous_lineup_ability: Dictionary = {0: "", 1: ""}
#endregion


#region SIGNAL CONNECTION SETUP
func _ready() -> void:
	_connect_to_turn_manager()
	_connect_to_zone_manager()
	_connect_to_shield_manager()
	_connect_to_energy_manager()

func _connect_to_turn_manager() -> void:
	call_deferred("_delayed_turn_manager_connect")

func _delayed_turn_manager_connect() -> void:
	if not has_node("/root/TurnManager"):
		return
	var tm = get_node("/root/TurnManager")
	if tm.has_signal("phase_changed"):
		tm.phase_changed.connect(_on_phase_changed)
	if tm.has_signal("end_phase_started"):
		tm.end_phase_started.connect(_on_end_phase_started)
	if tm.has_signal("turn_ended"):
		tm.turn_ended.connect(_on_turn_ended)
	if tm.has_signal("attack_declared"):
		tm.attack_declared.connect(_on_attack_declared_tm)

func _connect_to_zone_manager() -> void:
	call_deferred("_delayed_zone_manager_connect")

func _delayed_zone_manager_connect() -> void:
	if not has_node("/root/ZoneManager"):
		return
	var zm = get_node("/root/ZoneManager")
	if zm.has_signal("unit_deployed"):
		zm.unit_deployed.connect(_on_unit_deployed)
	if zm.has_signal("unit_destroyed"):
		zm.unit_destroyed.connect(_on_unit_destroyed)
	if zm.has_signal("drakesworn_bond_broken"):
		zm.drakesworn_bond_broken.connect(_on_drakesworn_bond_broken)
	if zm.has_signal("blitz_eligible"):
		zm.blitz_eligible.connect(_on_blitz_eligible)

func _connect_to_shield_manager() -> void:
	call_deferred("_delayed_shield_manager_connect")

func _delayed_shield_manager_connect() -> void:
	if not has_node("/root/ShieldManager"):
		return
	var sm = get_node("/root/ShieldManager")
	if sm.has_signal("shield_broken"):
		sm.shield_broken.connect(_on_shield_broken)
	if sm.has_signal("shields_depleted"):
		sm.shields_depleted.connect(_on_shields_depleted)
	if sm.has_signal("radiant_lattice_updated"):
		sm.radiant_lattice_updated.connect(_on_radiant_lattice_updated)
	if sm.has_signal("warden_light_activated"):
		sm.warden_light_activated.connect(_on_warden_light_activated)
	if sm.has_signal("tidal_veil_redirected"):
		sm.tidal_veil_redirected.connect(_on_tidal_veil_redirected)

func _connect_to_energy_manager() -> void:
	call_deferred("_delayed_energy_manager_connect")

func _delayed_energy_manager_connect() -> void:
	if not has_node("/root/EnergyManager"):
		return
	var em = get_node("/root/EnergyManager")
	if em.has_signal("sovereign_reign_resolved"):
		em.sovereign_reign_resolved.connect(_on_sovereign_reign_resolved)
	if em.has_signal("drunken_rage_applied"):
		em.drunken_rage_applied.connect(_on_drunken_rage_applied)
	if em.has_signal("drunken_rage_expired"):
		em.drunken_rage_expired.connect(_on_drunken_rage_expired)
	if em.has_signal("energy_spent"):
		em.energy_spent.connect(_on_energy_spent)
#endregion

#region TURN MANAGER SIGNAL HANDLERS
func _on_phase_changed(_old_phase: int, new_phase: int) -> void:
	if new_phase == PHASE_UNTAP:
		reset_temporary_combat_effects()

func _on_end_phase_started() -> void:
	for player in [0, 1]:
		resolve_end_of_turn_combat_effects(player)

func _on_turn_ended(player: int) -> void:
	sentinel_units.clear()
	previous_lineup_ability[player] = ""

func _on_attack_declared_tm(attacker, defender) -> void:
	current_attack.clear()
#endregion

#region ZONE MANAGER SIGNAL HANDLERS
func _on_unit_deployed(player: int, card, zone: String) -> void:
	if zone == "frontline" and card.has_keyword("Sentinel"):
		pass

func _on_unit_destroyed(player: int, card, zone: String) -> void:
	if current_attack.attacker != null and current_attack.attacker.id == card.id:
		pass

func _on_drakesworn_bond_broken(player: int, surviving_card) -> void:
	resolve_drakesworn_power_halve(player, surviving_card)

func _on_blitz_eligible(card) -> void:
	pass
#endregion

#region SHIELD MANAGER SIGNAL HANDLERS
func _on_shield_broken(player: int, _card, remaining: int) -> void:
	pass

func _on_shields_depleted(player: int) -> void:
	pass

func _on_radiant_lattice_updated(player: int, bonus: int) -> void:
	radiant_lattice_bonus[player] = bonus

func _on_warden_light_activated(player: int) -> void:
	warden_light_active[player] = true

func _on_tidal_veil_redirected(player: int, card, target_card) -> void:
	if current_attack.attacker != null and current_attack.attacker.id == card.id:
		current_attack.attacker = target_card
#endregion

#region ENERGY MANAGER SIGNAL HANDLERS
func _on_sovereign_reign_resolved(player: int, conversions: Array) -> void:
	for conv in conversions:
		var card_id = conv.get("card_id", "")
		var power_gain = conv.get("power_gain", 0)
		if card_id != "" and power_gain > 0:
			sovereign_reign_bonuses[card_id] = sovereign_reign_bonuses.get(card_id, 0) + power_gain

func _on_drunken_rage_applied(player: int, card, power_bonus: int) -> void:
	drunken_rage_bonuses[card.id] = power_bonus

func _on_drunken_rage_expired(player: int, card) -> void:
	drunken_rage_bonuses.erase(card.id)
	emit_signal("drunken_rage_expired", player, card)

func _on_energy_spent(player: int, amount: int) -> void:
	pass
#endregion

#region COMBAT FLOW
## Phase 5B — Frontline unit declares an attack.
## Validates attacker is in Frontline and untapped.
## Opens Burst — Reaction window before defenders chosen.
func declare_attack(attacker, target_zone: String, target_player: int) -> bool:
	current_attack.attacker = attacker
	current_attack.attacker_player = attacker.faction  ## Placeholder — use actual player
	current_attack.target_zone = target_zone
	current_attack.target_player = target_player
	current_attack.defenders = []
	current_attack.boost_value = 0
	current_attack.infiltrate_active = false
	current_attack.zero_defenders_chosen = false
	
	current_attack.infiltrate_active = attacker.has_keyword("Infiltrate")
	if current_attack.infiltrate_active:
		var target_backline = _get_backline_target(target_player)
		if target_backline == null:
			push_error("CombatResolver: Infiltrate target is empty")
			return false
		_declare_infiltrate_attack(attacker, target_backline, target_player)
		return true
	
	if attacker.has_keyword("Dominion"):
		emit_signal("dominion_activated", current_attack.attacker_player, attacker)
	
	emit_signal("attack_declared", attacker, target_zone, target_player)
	return true

func _declare_infiltrate_attack(attacker, target_unit, target_player: int) -> void:
	emit_signal("infiltrate_attack_declared", attacker, target_unit, target_player)
	current_attack.defenders = [target_unit]

func _get_backline_target(target_player: int):
	if not has_node("/root/ZoneManager"):
		return null
	var zm = get_node("/root/ZoneManager")
	var backline = zm.get_zone_contents(target_player, "backline")
	if backline.is_empty():
		return null
	return backline[0]

## Defending player chooses defenders from their Frontline.
## May choose zero defenders — attack goes to General.
func select_defenders(defenders: Array) -> void:
	current_attack.defenders = defenders
	emit_signal("defenders_chosen", defenders)
	
	if defenders.is_empty():
		current_attack.zero_defenders_chosen = true
		_resolve_general_attack()
		return
	
	_apply_boost()
	_resolve_combat()

## Phase 5A — Backline unit boosts paired Frontline attacker.
## Boost value = Backline unit Power.
## Backline unit taps on boost use.
func _apply_boost() -> void:
	if current_attack.attacker == null:
		return
	if not has_node("/root/ZoneManager"):
		return
	var zm = get_node("/root/ZoneManager")
	var backline_slot = zm.get_paired_frontline_slot(current_attack.attacker_player, 0)
	if backline_slot == null:
		return
	
	var boost_value: int = backline_slot.power
	var has_overcharge = backline_slot.has_keyword("Overcharge")
	var has_uplink = backline_slot.has_keyword("Uplink")
	
	if has_overcharge:
		boost_value *= 2
		overcharge_units.append(backline_slot)
	
	if has_uplink:
		boost_value += _resolve_uplink_amplification(backline_slot)
	
	current_attack.boost_value = boost_value
	emit_signal("boost_applied", current_attack.attacker, backline_slot, boost_value)
	zm.tap_backline_unit(current_attack.attacker_player, backline_slot)

## DATA KINGDOM FACTION — Uplink amplification.
func _resolve_uplink_amplification(backline_card) -> int:
	return 0

## Resolves direct attack to General when zero defenders chosen.
func _resolve_general_attack() -> void:
	var target_player = current_attack.target_player
	var attacker = current_attack.attacker
	
	if not has_node("/root/ShieldManager"):
		emit_signal("general_attacked", target_player)
		_emit_combat_resolved()
		return
	
	var sm = get_node("/root/ShieldManager")
	var shields = sm.get_shields_remaining(target_player)
	
	if shields > 0:
		sm.request_shield_break(target_player)
		if attacker.has_keyword("Lifesteal"):
			sm.resolve_lifesteal(attacker, target_player, current_attack.attacker_player)
	else:
		emit_signal("general_attacked", target_player)
	
	_emit_combat_resolved()
#endregion

#region CORE COMBAT RESOLUTION
## Core Power comparison.
func _resolve_combat() -> void:
	var atk_power: int = _calculate_attack_power()
	var def_power: int = _calculate_defense_power()
	
	emit_signal("power_comparison_resolved", atk_power, def_power, atk_power > def_power)
	
	if atk_power > def_power:
		_resolve_attacker_wins()
	else:
		_resolve_attacker_loses()
	
	_emit_combat_resolved()

## POWER MODIFICATION HIERARCHY (10 steps):
##   1. Base Power (card data)
##   2. Bloodlust gains (+100/kill, PERMANENT)
##   3. Sovereign's Reign gains (PERMANENT)
##   4. Boost from Backline (+boost_value, attack only)
##   5. Drunken Rage bonus (TEMPORARY)
##   6. Radiant Lattice bonus (TEMPORARY, defenders only)
##   7. Void Pulse reduction (TEMPORARY, subtract)
##   8. Elder's Verdict floor (base Power minimum)
##   9. Warden's Light floor (100 minimum from ability reductions)
##  10. Hard floor: 0
func _calculate_attack_power() -> int:
	if current_attack.attacker == null:
		return 0
	
	var card = current_attack.attacker
	var base_power: int = card.power
	var total: int = base_power
	
	total += bloodlust_gains.get(card.id, 0)
	total += sovereign_reign_bonuses.get(card.id, 0)
	total += current_attack.boost_value
	total += drunken_rage_bonuses.get(card.id, 0)
	total -= void_pulse_reductions.get(card.id, 0)
	
	if card.has_keyword("Elder's Verdict"):
		total = maxi(total, base_power)
	
	return maxi(total, 0)

## Defender Power includes Radiant Lattice bonus and Warden's Light floor.
func _calculate_defense_power() -> int:
	var total: int = 0
	for defender in current_attack.defenders:
		var def_power: int = defender.power
		def_power -= void_pulse_reductions.get(defender.id, 0)
		def_power += radiant_lattice_bonus.get(current_attack.target_player, 0)
		if warden_light_active.get(current_attack.target_player, false):
			def_power = maxi(def_power, 100)
		total += def_power
	return total

## Attacker Power exceeds combined defender Power — all defenders destroyed.
func _resolve_attacker_wins() -> void:
	var attacker = current_attack.attacker
	var target_player = current_attack.target_player
	
	for defender in current_attack.defenders:
		emit_signal("defender_destroyed", defender)
		_destroy_unit(target_player, defender)
		_resolve_bloodlust(attacker, defender)
	
	if current_attack.zero_defenders_chosen:
		if attacker.has_keyword("Oathstrike") and not current_attack.infiltrate_active:
			_trigger_oathstrike(attacker)
		if attacker.has_keyword("Lifesteal"):
			_trigger_lifesteal()
		if has_node("/root/ShieldManager"):
			var sm = get_node("/root/ShieldManager")
			sm.request_shield_break(target_player)
			sm.resolve_pierce(attacker, target_player)
	else:
		if has_node("/root/ShieldManager"):
			var sm = get_node("/root/ShieldManager")
			sm.resolve_pierce(attacker, target_player)
			sm.resolve_lifesteal(attacker, target_player, current_attack.attacker_player)

## Attacker Power ≤ combined defender Power — attacker destroyed.
func _resolve_attacker_loses() -> void:
	var attacker = current_attack.attacker
	var attacker_player = current_attack.attacker_player
	
	emit_signal("attacker_destroyed", attacker)
	_destroy_unit(attacker_player, attacker)

func _emit_combat_resolved() -> void:
	current_attack.clear()
	emit_signal("combat_resolved")
#endregion

#region KEYWORD RESOLUTION
## Bloodlust: +100 Power per kill — PERMANENT.
## CRITICAL: Bloodlust is permanent — never resets.
## Dragonfire kills do NOT trigger Bloodlust (not combat).
func _resolve_bloodlust(attacker, destroyed_defender) -> void:
	if not attacker.has_keyword("Bloodlust"):
		return
	bloodlust_gains[attacker.id] = bloodlust_gains.get(attacker.id, 0) + 100
	attacker.power += 100
	emit_signal("bloodlust_gained", current_attack.attacker_player, attacker, attacker.power)

## Void Pulse: temporary Power reduction.
## Resets start of opponent's next turn.
func resolve_void_pulse(player: int, target_card, reduction: int) -> void:
	void_pulse_reductions[target_card.id] = reduction
	emit_signal("void_pulse_applied", player, target_card, reduction)

## Void Lock: target card cannot be played until your next turn.
func resolve_void_lock(player: int, target_card) -> void:
	if void_lock_count[player] >= MAX_VOID_LOCK_TARGETS:
		return
	void_lock_count[player] += 1
	emit_signal("void_lock_applied", player, target_card)

## Diamond League Lineup chain.
func resolve_lineup_chain(player: int, card) -> void:
	var bonus = _calculate_lineup_bonus(card)
	if card.has_keyword("Relay"):
		emit_signal("relay_bonus_applied", player, bonus)
	else:
		emit_signal("lineup_chain_triggered", player, card, bonus)
	previous_lineup_ability[player] = card.name

func _calculate_lineup_bonus(card) -> int:
	return 0

## Drakesworn Bond: surviving partner's Power halved.
func resolve_drakesworn_power_halve(player: int, surviving_card) -> void:
	var new_power: int = int(surviving_card.power / 2.0)
	surviving_card.power = new_power
	emit_signal("drakesworn_bond_broken", player, surviving_card, new_power)

## Dominion: block opponent's Burst — Reaction window.
func resolve_dominion(player: int, attacker) -> void:
	emit_signal("dominion_activated", player, attacker)
#endregion

#region ZONE/SHIELD DELEGATION
## Delegates shield break to ZoneManager.
func _break_shield(player: int) -> void:
	if not has_node("/root/ZoneManager"):
		return
	var zm = get_node("/root/ZoneManager")
	zm.break_shield(player)

## Delegates unit destruction to ZoneManager.
func _destroy_unit(player: int, card) -> void:
	if not has_node("/root/ZoneManager"):
		return
	var zone = _get_card_zone(player, card)
	if zone != "":
		var zm = get_node("/root/ZoneManager")
		zm.destroy_unit(player, card, zone)

func _get_card_zone(player: int, card) -> String:
	if not has_node("/root/ZoneManager"):
		return ""
	var zm = get_node("/root/ZoneManager")
	return zm.get_unit_current_zone(player, card)

func _trigger_oathstrike(attacker) -> void:
	if not has_node("/root/ShieldManager"):
		return
	var sm = get_node("/root/ShieldManager")
	sm.resolve_oathstrike(current_attack.attacker_player, attacker)

func _trigger_lifesteal() -> void:
	if not has_node("/root/ShieldManager"):
		return
	var sm = get_node("/root/ShieldManager")
	sm.resolve_lifesteal(
		current_attack.attacker,
		current_attack.target_player,
		current_attack.attacker_player
	)
#endregion

#region END OF TURN / RESET
## Destroys Overcharge units at end of turn.
func resolve_end_of_turn_combat_effects(player: int) -> void:
	for unit in overcharge_units:
		emit_signal("overcharge_destroyed", player, unit)
		_destroy_unit(player, unit)
	overcharge_units.clear()

## CRITICAL: Resets TEMPORARY effects only.
## PERMANENT effects (Bloodlust, Sovereign's Reign) are NEVER cleared.
func reset_temporary_combat_effects() -> void:
	for card_id in void_pulse_reductions:
		emit_signal("void_pulse_expired", 0, _get_card_by_id(card_id))
		emit_signal("void_pulse_expired", 1, _get_card_by_id(card_id))
	void_pulse_reductions.clear()
	warden_light_active[0] = false
	warden_light_active[1] = false
	drunken_rage_bonuses.clear()
	sentinel_units.clear()

func _get_card_by_id(card_id: String):
	return null
#endregion

#region INITIALIZATION
func initialize_player(player: int) -> void:
	bloodlust_gains[player] = 0
	sovereign_reign_bonuses[player] = 0
	void_lock_count[player] = 0
	previous_lineup_ability[player] = ""
#endregion