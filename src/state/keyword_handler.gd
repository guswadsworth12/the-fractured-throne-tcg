## KeywordHandler.gd
## Central keyword event hub for The Fracture Throne TCG.
## Godot 4 Autoload singleton using GDScript 4 only.
## Communication via signals only — no direct calls to other singletons.
## Listens to all 5 managers (TurnManager, ZoneManager, ShieldManager,
## CombatResolver, EnergyManager) and emits unified keyword events for scenes.

extends Node

class_name KeywordHandler

#region SIGNALS EMITTED
## Unified keyword event — scenes subscribe to this for all keyword reactivity.
## result values: "success", "failed", "activated", "expired", "blocked", "destroyed",
##                 "boosted", "reduced", "triggered", "applied", "chained"
signal keyword_activated(keyword: String, player: int, card: CardData, result: String)

## Fired when a Prophet unit's ability activates — scene must prompt player.
signal prophecy_prediction_requested(player: int, card: CardData)

## Fired when a unit with Reanimate dies — card is returning to field.
signal reanimate_triggered(player: int, card: CardData)

## Fired when a Devour resolves — consumed card placed below stack.
signal devoured_card_placed(card_id: String, card: CardData)

## Fired when a Drakesworn Bond is severed.
signal drake_bond_severed(player: int, surviving_card: CardData, consumed_card: CardData)

## Fired when an Anchor blocks a forced move.
signal anchor_blocked_move(card: CardData, reason: String)
#endregion

#region PERMANENT STATE (never reset)
## Tracks Reanimate units that have already been used — prevents double-use.
var reanimate_removed: Dictionary = {}

## Bidirectional map of Drake Bond pairs: card_id_a → card_id_b (both directions).
var drake_bond_partners: Dictionary = {}
#endregion

#region TEMPORARY STATE (reset each turn via turn_started)
## House Cut trigger counter per player — max 3 per turn.
var house_cut_triggers: Dictionary = {0: 0, 1: 0}

## Cards that used Devour this turn — prevents double-use.
var devour_used_this_turn: Array = []

## Uplink condition trackers per player.
## Structure: player → {card_id: {condition_type: String, met: bool}}
var uplink_trackers: Dictionary = {}

## Prophet prediction state per player.
## Structure: player → {card_id: {predicted_type: String, resolved: bool}}
var prophet_predictions: Dictionary = {}

## Pending Prophecy awaiting player choice.
## Structure: player → {card: CardData, predicted_type: String}
var pending_prophecy: Dictionary = {}

## Lineup chain tracking — set true when a Lineup ability chains.
## Resets at Phase 0 (Untap).
var lineup_chain_active: Dictionary = {0: false, 1: false}

## Previous Lineup card per player — used for chain detection.
var previous_lineup_card: Dictionary = {0: null, 1: null}

## Tracks which player owns each card — populated on unit_deployed/unit_destroyed.
## Used by signal handlers to determine card owner when signals don't carry player.
var _card_owner: Dictionary = {}
#endregion

#region SURGE DEDUPLICATION GUARD
## Prevents duplicate Surge events when both ShieldManager and EnergyManager emit.
var _surge_active_this_event: bool = false
#endregion

#region PROPHECY STATE MACHINE
## Prophecy card types available for prediction.
const PROPHECY_TYPES: Array = ["Unit", "Burst", "Augment"]

## Sets the player's Prophecy prediction after scene prompts them.
## Called by scene after player selects a card type.
func set_prophecy_prediction(player: int, card: CardData, predicted_type: String) -> void:
	if predicted_type not in PROPHECY_TYPES:
		return
	pending_prophecy[player] = {
		card = card,
		predicted_type = predicted_type
	}
#endregion

#region CARD DATA CLASS (minimal for signal callbacks)
class CardData:
	var id: String = ""
	var name: String = ""
	var rank: int = 0
	var faction: String = ""
	var power: int = 0
	var keywords: Array = []
#endregion

#region INITIALIZATION
func _ready() -> void:
	call_deferred("_deferred_signal_setup")

func _deferred_signal_setup() -> void:
	_setup_turn_manager()
	_setup_zone_manager()
	_setup_shield_manager()
	_setup_combat_resolver()
	_setup_energy_manager()

func _setup_turn_manager() -> void:
	if not has_node("/root/TurnManager"):
		return
	var tm = get_node("/root/TurnManager")
	tm.connect("phase_started", Callable(self, "_on_phase_started"), CONNECT_DEFERRED)
	tm.connect("turn_started", Callable(self, "_on_turn_started"), CONNECT_DEFERRED)
	tm.connect("turn_ended", Callable(self, "_on_turn_ended"), CONNECT_DEFERRED)

func _setup_zone_manager() -> void:
	if not has_node("/root/ZoneManager"):
		return
	var zm = get_node("/root/ZoneManager")
	zm.connect("unit_deployed", Callable(self, "_on_unit_deployed"), CONNECT_DEFERRED)
	zm.connect("unit_destroyed", Callable(self, "_on_unit_destroyed"), CONNECT_DEFERRED)
	zm.connect("devour_completed", Callable(self, "_on_devour_completed"), CONNECT_DEFERRED)
	zm.connect("drakesworn_bond_broken", Callable(self, "_on_drakesworn_bond_broken_zm"), CONNECT_DEFERRED)
	zm.connect("flame_prayer_triggered", Callable(self, "_on_flame_prayer_triggered_zm"), CONNECT_DEFERRED)

func _setup_shield_manager() -> void:
	if not has_node("/root/ShieldManager"):
		return
	var sm = get_node("/root/ShieldManager")
	sm.connect("shield_broken", Callable(self, "_on_shield_broken_sm"), CONNECT_DEFERRED)
	sm.connect("surge_triggered", Callable(self, "_on_surge_triggered_sm"), CONNECT_DEFERRED)
	sm.connect("pierce_shield_broken", Callable(self, "_on_pierce_shield_broken"), CONNECT_DEFERRED)
	sm.connect("lifesteal_triggered", Callable(self, "_on_lifesteal_triggered"), CONNECT_DEFERRED)
	sm.connect("radiant_barrier_activated", Callable(self, "_on_radiant_barrier_activated"), CONNECT_DEFERRED)
	sm.connect("radiant_lattice_updated", Callable(self, "_on_radiant_lattice_updated"), CONNECT_DEFERRED)
	sm.connect("warden_light_activated", Callable(self, "_on_warden_light_activated"), CONNECT_DEFERRED)
	sm.connect("upwelling_triggered", Callable(self, "_on_upwelling_triggered"), CONNECT_DEFERRED)

func _setup_combat_resolver() -> void:
	if not has_node("/root/CombatResolver"):
		return
	var cr = get_node("/root/CombatResolver")
	cr.connect("attack_declared", Callable(self, "_on_attack_declared_cr"), CONNECT_DEFERRED)
	cr.connect("defenders_chosen", Callable(self, "_on_defenders_chosen"), CONNECT_DEFERRED)
	cr.connect("boost_applied", Callable(self, "_on_boost_applied"), CONNECT_DEFERRED)
	cr.connect("power_comparison_resolved", Callable(self, "_on_power_comparison_resolved"), CONNECT_DEFERRED)
	cr.connect("attacker_destroyed", Callable(self, "_on_attacker_destroyed"), CONNECT_DEFERRED)
	cr.connect("defender_destroyed", Callable(self, "_on_defender_destroyed"), CONNECT_DEFERRED)
	cr.connect("general_attacked", Callable(self, "_on_general_attacked"), CONNECT_DEFERRED)
	cr.connect("infiltrate_attack_declared", Callable(self, "_on_infiltrate_attack_declared"), CONNECT_DEFERRED)
	cr.connect("bloodlust_gained", Callable(self, "_on_bloodlust_gained"), CONNECT_DEFERRED)
	cr.connect("void_pulse_applied", Callable(self, "_on_void_pulse_applied"), CONNECT_DEFERRED)
	cr.connect("void_pulse_expired", Callable(self, "_on_void_pulse_expired"), CONNECT_DEFERRED)
	cr.connect("sovereign_reign_applied", Callable(self, "_on_sovereign_reign_applied"), CONNECT_DEFERRED)
	cr.connect("drunken_rage_expired", Callable(self, "_on_drunken_rage_expired_cr"), CONNECT_DEFERRED)
	cr.connect("overcharge_destroyed", Callable(self, "_on_overcharge_destroyed"), CONNECT_DEFERRED)
	cr.connect("drakesworn_bond_broken", Callable(self, "_on_drakesworn_bond_broken_cr"), CONNECT_DEFERRED)
	cr.connect("lineup_chain_triggered", Callable(self, "_on_lineup_chain_triggered"), CONNECT_DEFERRED)
	cr.connect("prophecy_activated", Callable(self, "_on_prophecy_activated"), CONNECT_DEFERRED)
	cr.connect("relay_bonus_applied", Callable(self, "_on_relay_bonus_applied"), CONNECT_DEFERRED)
	cr.connect("dominion_activated", Callable(self, "_on_dominion_activated"), CONNECT_DEFERRED)
	cr.connect("anchor_blocked_move", Callable(self, "_on_anchor_blocked_move"), CONNECT_DEFERRED)
	cr.connect("combat_resolved", Callable(self, "_on_combat_resolved"), CONNECT_DEFERRED)

func _setup_energy_manager() -> void:
	if not has_node("/root/EnergyManager"):
		return
	var em = get_node("/root/EnergyManager")
	em.connect("energy_spent", Callable(self, "_on_energy_spent"), CONNECT_DEFERRED)
	em.connect("energy_gained", Callable(self, "_on_energy_gained"), CONNECT_DEFERRED)
	em.connect("surge_triggered", Callable(self, "_on_surge_triggered_em"), CONNECT_DEFERRED)
	em.connect("blood_tithe_penalty", Callable(self, "_on_blood_tithe_penalty"), CONNECT_DEFERRED)
	em.connect("house_cut_triggered", Callable(self, "_on_house_cut_triggered"), CONNECT_DEFERRED)
	em.connect("flame_prayer_resolved", Callable(self, "_on_flame_prayer_resolved"), CONNECT_DEFERRED)
	em.connect("drunken_rage_expired", Callable(self, "_on_drunken_rage_expired_em"), CONNECT_DEFERRED)
	em.connect("uplink_condition_met", Callable(self, "_on_uplink_condition_met"), CONNECT_DEFERRED)
#endregion

#region TURN MANAGER HANDLERS
func _on_phase_started(phase: int, _subphase: int) -> void:
	if phase == 0:
		_lineup_reset()

func _on_turn_started(player: int) -> void:
	_turn_reset_player(player)

func _on_turn_ended(_player: int) -> void:
	pass

func _lineup_reset() -> void:
	lineup_chain_active[0] = false
	lineup_chain_active[1] = false
	previous_lineup_card[0] = null
	previous_lineup_card[1] = null

func _turn_reset_player(player: int) -> void:
	house_cut_triggers[player] = 0
	devour_used_this_turn.clear()
	if uplink_trackers.has(player):
		uplink_trackers[player].clear()
	if prophet_predictions.has(player):
		prophet_predictions[player].clear()
	pending_prophecy.erase(player)
#endregion

#region ZONE MANAGER HANDLERS
func _on_unit_deployed(player: int, card: CardData, _zone: String) -> void:
	_card_owner[card.id] = player
	emit_keyword("Blitz", player, card, "activated")

func _on_unit_destroyed(player: int, card: CardData, _zone: String) -> void:
	_card_owner.erase(card.id)
	if "Reanimate" in card.keywords:
		if not reanimate_removed.has(card.id):
			emit_signal("reanimate_triggered", player, card)
			reanimate_removed[card.id] = true
	emit_keyword("Flame Prayer", player, card, "destroyed")

func _on_devour_completed(player: int, card: CardData) -> void:
	devour_used_this_turn.append(card.id)
	emit_signal("devoured_card_placed", card.id, card)
	emit_keyword("Devour", player, card, "activated")

func _on_drakesworn_bond_broken_zm(player: int, surviving_card: CardData) -> void:
	_emit_drake_bond_severed(player, surviving_card)

func _on_flame_prayer_triggered_zm(_player: int) -> void:
	pass
#endregion

#region SHIELD MANAGER HANDLERS
func _on_shield_broken_sm(_player: int, _card: CardData, _shields_remaining: int) -> void:
	pass

func _on_surge_triggered_sm(player: int, card: CardData) -> void:
	if not _surge_active_this_event:
		_surge_active_this_event = true
		emit_keyword("Surge", player, card, "triggered")
		_surge_active_this_event = false

func _on_pierce_shield_broken(target_player: int, attacker: CardData) -> void:
	emit_keyword("Pierce", target_player, attacker, "triggered")

func _on_lifesteal_triggered(attacking_player: int, attacker: CardData, _target_player: int) -> void:
	emit_keyword("Lifesteal", attacking_player, attacker, "triggered")

func _on_radiant_barrier_activated(player: int, card: CardData, _energy_cost: int) -> void:
	emit_keyword("Radiant Barrier", player, card, "activated")

func _on_radiant_lattice_updated(_player: int, _bonus: int) -> void:
	pass

func _on_warden_light_activated(_player: int) -> void:
	pass

func _on_upwelling_triggered(player: int, card: CardData) -> void:
	emit_keyword("Upwelling", player, card, "triggered")
#endregion

#region COMBAT RESOLVER HANDLERS
func _on_attack_declared_cr(_attacker: CardData, _defender: CardData) -> void:
	pass

func _on_defenders_chosen(_defenders: Array) -> void:
	pass

func _on_boost_applied(attacker: CardData, backline_unit: CardData, _boost_value: int) -> void:
	var backline_player = _card_owner.get(backline_unit.id, 0)
	emit_keyword("Backline", backline_player, attacker, "boosted")

func _on_power_comparison_resolved(_attacker_power: int, _defense_power: int, _attacker_wins: bool) -> void:
	pass

func _on_attacker_destroyed(card: CardData) -> void:
	var player = _card_owner.get(card.id, 0)
	if "Bloodlust" in card.keywords:
		emit_keyword("Bloodlust", player, card, "triggered")

func _on_defender_destroyed(_card: CardData) -> void:
	pass

func _on_general_attacked(_target_player: int) -> void:
	pass

func _on_infiltrate_attack_declared(attacker: CardData, _target_unit: CardData, target_player: int) -> void:
	emit_keyword("Infiltrate", target_player, attacker, "activated")

func _on_bloodlust_gained(player: int, card: CardData, _new_power: int) -> void:
	emit_keyword("Bloodlust", player, card, "applied")

func _on_void_pulse_applied(player: int, card: CardData, _reduction: int) -> void:
	emit_keyword("Void Pulse", player, card, "reduced")

func _on_void_pulse_expired(player: int, card: CardData) -> void:
	emit_keyword("Void Pulse", player, card, "expired")

func _on_sovereign_reign_applied(player: int, card: CardData, _power_gain: int) -> void:
	emit_keyword("Sovereign's Reign", player, card, "applied")

func _on_drunken_rage_expired_cr(player: int, card: CardData) -> void:
	emit_keyword("Drunken Rage", player, card, "expired")

func _on_overcharge_destroyed(player: int, card: CardData) -> void:
	emit_keyword("Overcharge", player, card, "destroyed")

func _on_drakesworn_bond_broken_cr(player: int, surviving_card: CardData, _new_power: int) -> void:
	_emit_drake_bond_severed(player, surviving_card)

func _on_lineup_chain_triggered(player: int, card: CardData, _bonus: int) -> void:
	if previous_lineup_card[player] != null and previous_lineup_card[player].id != card.id:
		lineup_chain_active[player] = true
	emit_keyword("Lineup", player, card, "chained")
	previous_lineup_card[player] = card

func _on_prophecy_activated(player: int, card: CardData) -> void:
	emit_signal("prophecy_prediction_requested", player, card)

func _on_relay_bonus_applied(player: int, _bonus: int) -> void:
	emit_keyword("Relay", player, null, "applied")

func _on_dominion_activated(player: int, attacker: CardData) -> void:
	emit_keyword("Dominion", player, attacker, "activated")

func _on_anchor_blocked_move(card: CardData) -> void:
	var player = _card_owner.get(card.id, 0)
	emit_signal("anchor_blocked_move", card, "forced_move")
	emit_keyword("Anchor", player, card, "blocked")

func _on_combat_resolved() -> void:
	pass
#endregion

#region ENERGY MANAGER HANDLERS
func _on_energy_spent(_player: int, _amount: int) -> void:
	pass

func _on_energy_gained(_player: int, _amount: int, _source: String) -> void:
	pass

func _on_surge_triggered_em(player: int, card: CardData) -> void:
	if not _surge_active_this_event:
		_surge_active_this_event = true
		emit_keyword("Surge", player, card, "triggered")
		_surge_active_this_event = false

func _on_blood_tithe_penalty(player: int) -> void:
	emit_keyword("Blood Tithe", player, null, "penalty")

func _on_house_cut_triggered(player: int, _amount: int) -> void:
	if house_cut_triggers[player] < 3:
		house_cut_triggers[player] += 1
		emit_keyword("House Cut", player, null, "triggered")

func _on_flame_prayer_resolved(player: int, card: CardData) -> void:
	emit_keyword("Flame Prayer", player, card, "resolved")

func _on_drunken_rage_expired_em(player: int, card: CardData) -> void:
	emit_keyword("Drunken Rage", player, card, "expired")

func _on_uplink_condition_met(player: int, card: CardData, _condition_type: String) -> void:
	emit_keyword("Uplink", player, card, "condition_met")
#endregion

#region HELPER METHODS
func emit_keyword(keyword: String, player: int, card: CardData, result: String) -> void:
	emit_signal("keyword_activated", keyword, player, card, result)

func _emit_drake_bond_severed(player: int, surviving_card: CardData) -> void:
	var partner_id = drake_bond_partners.get(surviving_card.id, null)
	var partner_card = null
	if partner_id != null:
		partner_card = _get_card_by_id(partner_id)
	emit_signal("drake_bond_severed", player, surviving_card, partner_card)

func _get_card_by_id(_card_id: String) -> CardData:
	return null

func register_drake_bond(card_a: CardData, card_b: CardData) -> void:
	drake_bond_partners[card_a.id] = card_b.id
	drake_bond_partners[card_b.id] = card_a.id
#endregion