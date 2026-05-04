## ZoneManager.gd
## Manages all zone state for The Fracture Throne TCG.
## Godot 4 Autoload singleton using GDScript 4 only.
## Communication via signals only — no direct calls to other singletons.
## Scenes read zone state from this singleton — never write to it.
## TurnManager signals drive all phase transitions — ZoneManager listens and responds.

extends Node

class_name ZoneManager

#region ZONE CONSTANTS
const ZONE_FRONTLINE := "frontline"
const ZONE_BACKLINE := "backline"
const ZONE_COMMAND := "command_zone"
const ZONE_SHIELD := "shield_zone"
const ZONE_ENERGY := "energy_zone"
const ZONE_REMnant := "remnant_zone"

const MAX_FRONTLINE := 4
const MAX_BACKLINE := 4
const MAX_SHIELD := 6
const MAX_COMMAND := 1
#endregion

#region SIGNALS
## Emitted when any zone's contents change.
## zone_changed(player: int, zone_name: String, contents: Array)
signal zone_changed(player: int, zone_name: String, contents: Array)

## Emitted when a unit is deployed to frontline or backline.
## unit_deployed(player: int, card, zone: String)
signal unit_deployed(player: int, card, zone: String)

## Emitted when a unit moves between zones.
## unit_moved(player: int, card, from_zone: String, to_zone: String)
signal unit_moved(player: int, card, from_zone: String, to_zone: String)

## Emitted when a unit is destroyed and sent to remnant_zone.
## unit_destroyed(player: int, card, zone: String)
signal unit_destroyed(player: int, card, zone: String)

## Emitted when a backline unit taps (e.g., to boost).
## unit_tapped(player: int, card)
signal unit_tapped(player: int, card)

## Emitted when backline units are untapped in Phase 0.
## unit_untapped(player: int, card)
signal unit_untapped(player: int, card)

## Emitted when a General advances in rank.
## general_advanced(player: int, new_rank: int, card)
signal general_advanced(player: int, new_rank: int, card)

## Emitted when a Rift card is played.
## rift_played(card)
signal rift_played(card)

## Emitted when a Rift is destroyed by a new Rift.
## rift_destroyed(card)
signal rift_destroyed(card)

## Emitted when a Shield breaks.
## shield_broken(player: int, card, shields_remaining: int)
signal shield_broken(player: int, card, shields_remaining: int)

## Emitted when a broken Shield has Surge keyword.
## surge_triggered(player: int, card)
signal surge_triggered(player: int, card)

## Emitted when Energy is spent.
## energy_spent(player: int, amount: int)
signal energy_spent(player: int, amount: int)

## Emitted when Singularity is triggered.
## singularity_triggered(player: int)
signal singularity_triggered(player: int)

## Emitted when a Legacy ability is activated from a buried General.
## legacy_ability_activated(player: int, card, ability_text: String)
signal legacy_ability_activated(player: int, card, ability_text: String)

## Emitted when a card is eligible for Blitz this turn.
## blitz_eligible(card)
signal blitz_eligible(card)

## Emitted when a Rot unit uses Devour.
## devour_completed(player: int, card)
signal devour_completed(player: int, card)

## Emitted when a Drake unit's bond is broken.
## drakesworn_bond_broken(player: int, surviving_card)
signal drakesworn_bond_broken(player: int, surviving_card)

## Emitted when a unit with Flame Prayer is destroyed.
## flame_prayer_triggered(player: int)
signal flame_prayer_triggered(player: int)

## Emitted when a General is destroyed (stack empty).
## general_destroyed(player: int)
signal general_destroyed(player: int)

## Emitted when a unit's ability zone changes (e.g., moving to/from backline).
## ability_zone_changed(card, new_zone: String)
signal ability_zone_changed(card, new_zone: String)
#endregion

#region STATE
## Zone contents per player: Dictionary[String, Array[CardData]]
## Keys: "frontline", "backline", "shield_zone", "energy_zone", "remnant_zone"
var _zones: Dictionary = {
	0: {
		ZONE_FRONTLINE: [],
		ZONE_BACKLINE: [],
		ZONE_SHIELD: [],
		ZONE_ENERGY: [],
		ZONE_REMnant: []
	},
	1: {
		ZONE_FRONTLINE: [],
		ZONE_BACKLINE: [],
		ZONE_SHIELD: [],
		ZONE_ENERGY: [],
		ZONE_REMnant: []
	}
}

## Cards deployed this turn — reset in Phase 0
## Keyed by player
var _deployed_this_turn: Dictionary = {
	0: [],
	1: []
}

## Tapped backline units — reset in Phase 0
## Keyed by player
var _tapped_units: Dictionary = {
	0: [],
	1: []
}

## Active Rift card (shared between players)
var _active_rift = null

## General advancement stacks per player
## Index 0 = Rank 1 base General, top = active General
var _general_stack: Dictionary = {
	0: [],
	1: []
}

## Legacy abilities from buried Generals with Legacy keyword
## Persists until current General is destroyed
var _legacy_abilities: Dictionary = {
	0: [],
	1: []
}

## Devoured cards per player (ROT FACTION)
## These go below Rank 1 base, are permanently visible, and have active Command abilities
## They are NOT part of the Advancement stack and cannot become active General
var _devoured_cards: Dictionary = {
	0: [],
	1: []
}
#endregion

#region CARD DATA CLASS
class CardData:
	var id: String = ""
	var name: String = ""
	var rank: int = 0
	var faction: String = ""
	var keywords: Array = []
	var power: int = 0
	var is_face_up: bool = false
	var reanimate_removed: bool = false
	var paired_card = null
	
	func _init(p_id := "", p_name := "", p_rank := 0, p_faction := "", p_power := 0):
		id = p_id
		name = p_name
		rank = p_rank
		faction = p_faction
		power = p_power
		keywords = []
		is_face_up = false
	
	func has_keyword(kw: String) -> bool:
		return kw in keywords
	
	func clone() : :
		var c := CardData.new(id, name, rank, faction, power)
		c.keywords = keywords.duplicate()
		c.is_face_up = is_face_up
		c.reanimate_removed = reanimate_removed
		return c
#endregion

#region SIGNAL CONNECTION SETUP
func _ready() -> void:
	call_deferred("_connect_to_turn_manager")

func _connect_to_turn_manager() -> void:
	if has_node("/root/TurnManager"):
		var tm = get_node("/root/TurnManager")
		if tm.has_signal("phase_started"):
			tm.phase_started.connect(_on_phase_started)

## Handles Phase 0 (Phase 0B: Refresh Phase) to untap backline units
func _on_phase_started(phase: int, _subphase: int) -> void:
	if phase == 0:
		_untap_all_backline_units()
#endregion

#region PUBLIC API - DEPLOYMENT
## Deploys a unit to frontline or backline.
##
## Validates:
## - zone must be frontline or backline
## - card Rank <= active General Rank for that player
## - zone not at capacity
##
## Emits: unit_deployed, zone_changed
## If card has Blitz: emits blitz_eligible(card) for TurnManager
##
## CRITICAL: Does NOT validate combat eligibility — CombatResolver handles that.
func deploy(player: int, card, zone: String) -> bool:
	if zone != ZONE_FRONTLINE and zone != ZONE_BACKLINE:
		push_error("ZoneManager.deploy: Invalid deploy target zone: " + zone)
		return false
	
	if not is_legal_deploy_target(zone):
		push_error("ZoneManager.deploy: Zone is not a legal deploy target: " + zone)
		return false
	
	var active_general_rank := get_active_general_rank(player)
	if card.rank > active_general_rank:
		push_error("ZoneManager.deploy: Card rank %d exceeds General rank %d" % [card.rank, active_general_rank])
		return false
	
	if is_zone_full(player, zone):
		if zone == ZONE_FRONTLINE and not is_zone_full(player, ZONE_BACKLINE):
			zone = ZONE_BACKLINE
		else:
			push_error("ZoneManager.deploy: Zone is full: " + zone)
			return false
	
	_zones[player][zone].append(card)
	_deployed_this_turn[player].append(card)
	
	emit_signal("unit_deployed", player, card, zone)
	emit_signal("zone_changed", player, zone, get_zone_contents(player, zone))
	
	if has_keyword(card, "Blitz"):
		emit_signal("blitz_eligible", card)
	
	return true
#endregion

#region PUBLIC API - MOVEMENT
## Moves a unit from its current zone to a target zone.
##
## Validates:
## - card not in deployed_this_turn
## - target zone not at capacity
## - card not Anchored (Anchor blocks forced moves only — voluntary moves allowed)
##
## Emits: unit_moved, zone_changed, ability_zone_changed
##
## CRITICAL: Anchor blocks forced moves only — voluntary player-initiated moves are allowed.
func move_unit(player: int, card, target_zone: String) -> bool:
	var current_zone := get_unit_current_zone(player, card)
	if current_zone == "":
		push_error("ZoneManager.move_unit: Card not found in any zone for player %d" % player)
		return false
	
	if card in _deployed_this_turn[player]:
		push_error("ZoneManager.move_unit: Cannot move unit deployed this turn")
		return false
	
	if is_zone_full(player, target_zone):
		push_error("ZoneManager.move_unit: Target zone is full: " + target_zone)
		return false
	
	if has_keyword(card, "Anchor"):
		push_warning("ZoneManager.move_unit: Card has Anchor — skipping forced move check")
	
	if current_zone == target_zone:
		push_error("ZoneManager.move_unit: Card already in target zone")
		return false
	
	_zones[player][current_zone].erase(card)
	_zones[player][target_zone].append(card)
	
	emit_signal("unit_moved", player, card, current_zone, target_zone)
	emit_signal("zone_changed", player, current_zone, get_zone_contents(player, current_zone))
	emit_signal("zone_changed", player, target_zone, get_zone_contents(player, target_zone))
	emit_signal("ability_zone_changed", card, target_zone)
	
	return true
#endregion

#region PUBLIC API - GENERAL ADVANCEMENT
## Advances the General by pushing a new card onto the stack.
##
## Validates:
## - card is same faction as current General
## - card Rank = current General Rank + 1
##
## Emits: general_advanced
## If previous General has Legacy: registers Command ability in legacy_abilities,
## emits legacy_ability_activated for KeywordHandler
##
## CRITICAL: Legacy applies to Command abilities ONLY — never Frontline or Backline abilities.
func advance_general(player: int, card) -> bool:
	if _general_stack[player].is_empty():
		push_error("ZoneManager.advance_general: No General in stack to advance from")
		return false
	
	var current_general = _general_stack[player].back()
	if card.faction != current_general.faction:
		push_error("ZoneManager.advance_general: Card faction %s does not match General faction %s" % [card.faction, current_general.faction])
		return false
	
	if card.rank != current_general.rank + 1:
		push_error("ZoneManager.advance_general: Card rank %d is not current General rank + 1 (%d)" % [card.rank, current_general.rank + 1])
		return false
	
	if has_keyword(current_general, "Legacy"):
		_legacy_abilities[player].append(current_general)
		emit_signal("legacy_ability_activated", player, current_general, "Command")
	
	_general_stack[player].append(card)
	emit_signal("general_advanced", player, card.rank, card)
	
	return true
#endregion

#region PUBLIC API - DESTRUCTION
## Destroys a unit and handles keyword interactions.
##
## Handles:
## - Reanimate: if card has Reanimate AND not permanently removed, return to previous zone at 100 Power
## - Flame Prayer: emit flame_prayer_triggered for EnergyManager
## - If card was in general_stack: pop stack, emit general_destroyed if empty
##
## Emits: unit_destroyed OR unit_deployed (if Reanimate triggers)
##
## CRITICAL: Surge triggers from Shield Zone entry ONLY — not from destroy_unit.
## CRITICAL: Reanimate can be permanently removed — check reanimate_removed flag per unit.
func destroy_unit(player: int, card, zone: String) -> void:
	_zones[player][zone].erase(card)
	
	if card.has_keyword("Reanimate") and not card.reanimate_removed:
		card.power = 100
		card.reanimate_removed = true
		if zone == ZONE_FRONTLINE and not is_zone_full(player, ZONE_BACKLINE):
			_zones[player][ZONE_BACKLINE].append(card)
		elif zone == ZONE_BACKLINE and not is_zone_full(player, ZONE_FRONTLINE):
			_zones[player][ZONE_FRONTLINE].append(card)
		else:
			_zones[player][ZONE_FRONTLINE].append(card)
		emit_signal("unit_deployed", player, card, ZONE_FRONTLINE)
		emit_signal("zone_changed", player, zone, get_zone_contents(player, zone))
		emit_signal("zone_changed", player, ZONE_FRONTLINE, get_zone_contents(player, ZONE_FRONTLINE))
		return
	
	if card.has_keyword("Flame Prayer"):
		emit_signal("flame_prayer_triggered", player)
	
	_zones[player][ZONE_REMnant].append(card)
	emit_signal("unit_destroyed", player, card, zone)
	emit_signal("zone_changed", player, zone, get_zone_contents(player, zone))
	emit_signal("zone_changed", player, ZONE_REMnant, get_zone_contents(player, ZONE_REMnant))
	
	if card in _general_stack[player]:
		_general_stack[player].pop_back()
		if _general_stack[player].is_empty():
			emit_signal("general_destroyed", player)
		else:
			var new_general = _general_stack[player].back()
			emit_signal("general_advanced", player, new_general.rank, new_general)
	
	if card.has_keyword("Devour"):
		_handle_devour(player, card)

## ROT FACTION: Handles Devour keyword
## Places card below the Rank 1 base card of the General stack
## Devoured cards are NEVER part of the Advancement stack proper
## Their Command ability is permanently active
## They cannot become active General
## They are NOT removed by Dimensional Retreat
## Emit devour_completed for KeywordHandler to track
func _handle_devour(player: int, card) -> void:
	if _general_stack[player].is_empty():
		push_error("ZoneManager._handle_devour: Cannot Devour with empty General stack")
		return
	
	_devoured_cards[player].append(card)
	emit_signal("devour_completed", player, card)
#endregion

#region PUBLIC API - BACKLINE UNTAP
## Untaps all backline units for a player in Phase 0.
##
## Emits: unit_untapped for each previously tapped unit
func untap_backline(player: int) -> void:
	var previously_tapped: Array = _tapped_units[player].duplicate()
	_tapped_units[player].clear()
	
	for card in previously_tapped:
		emit_signal("unit_untapped", player, card)

func _untap_all_backline_units() -> void:
	for player in [0, 1]:
		untap_backline(player)
#endregion

#region PUBLIC API - RIFT
## Plays a Rift card, destroying the current Rift if one exists.
##
## Emits: rift_destroyed (if existing Rift), rift_played
func play_rift(player: int, card) -> bool:
	if _active_rift != null:
		_zones[player][ZONE_REMnant].append(_active_rift)
		emit_signal("rift_destroyed", _active_rift)
	
	_active_rift = card
	emit_signal("rift_played", card)
	return true
#endregion

#region PUBLIC API - SHIELD
## Breaks the top shield and handles Surge keyword.
##
## CRITICAL: Surge triggers from Shield Zone entry ONLY.
## If broken card has Surge: move to energy_zone face-up, emit surge_triggered.
## If no Surge: move to energy_zone face-up directly.
##
## Emits: shield_broken, surge_triggered (if applicable), zone_changed (shield_zone and energy_zone)
func break_shield(player: int) -> bool:
	var shields: Array = _zones[player][ZONE_SHIELD]
	if shields.is_empty():
		push_error("ZoneManager.break_shield: No shields to break for player %d" % player)
		return false
	
	var card = shields.pop_back()
	var shields_remaining: int = shields.size()
	
	emit_signal("shield_broken", player, card, shields_remaining)
	
	card.is_face_up = true
	_zones[player][ZONE_ENERGY].append(card)
	
	if has_keyword(card, "Surge"):
		emit_signal("surge_triggered", player, card)
	
	emit_signal("zone_changed", player, ZONE_SHIELD, get_zone_contents(player, ZONE_SHIELD))
	emit_signal("zone_changed", player, ZONE_ENERGY, get_zone_contents(player, ZONE_ENERGY))
	
	return true
#endregion

#region PUBLIC API - ENERGY
## Spends Energy by moving face-up cards to remnant_zone.
##
## Validates face-up energy count >= amount
##
## Emits: energy_spent, zone_changed (energy_zone and remnant_zone)
func spend_energy(player: int, amount: int) -> bool:
	var energy_count: int = _zones[player][ZONE_ENERGY].size()
	if energy_count < amount:
		push_error("ZoneManager.spend_energy: Not enough energy. Have %d, need %d" % [energy_count, amount])
		return false
	
	for i in range(amount):
		var card = _zones[player][ZONE_ENERGY].pop_front()
		_zones[player][ZONE_REMnant].append(card)
	
	emit_signal("energy_spent", player, amount)
	emit_signal("zone_changed", player, ZONE_ENERGY, get_zone_contents(player, ZONE_ENERGY))
	emit_signal("zone_changed", player, ZONE_REMnant, get_zone_contents(player, ZONE_REMnant))
	
	return true
#endregion

#region PUBLIC API - SINGULARITY
## Triggers Singularity: shuffles remnant_zone into a new deck.
##
## NOTE: Shields are NEVER included — shield_zone is untouched.
## Spent Energy cards in remnant_zone re-enter play as normal cards.
##
## Emits: singularity_triggered, zone_changed (remnant_zone)
func trigger_singularity(player: int) -> bool:
	if not _zones[player][ZONE_REMnant].is_empty():
		_zones[player][ZONE_REMnant].clear()
	
	emit_signal("singularity_triggered", player)
	emit_signal("zone_changed", player, ZONE_REMnant, get_zone_contents(player, ZONE_REMnant))
	
	return true
#endregion

#region PUBLIC API - DRAKESWORN BOND
## Handles Drake unit destruction — halves surviving partner's Power.
## Emit drakesworn_bond_broken for CombatResolver to apply Power reduction.
func handle_drakesworn_bond_break(player: int, _destroyed_card, surviving_card) -> void:
	emit_signal("drakesworn_bond_broken", player, surviving_card)
#endregion

#region PUBLIC API - TAP BACKLINE
## Taps a backline unit when it boosts.
## Tapped units cannot respond to Reaction windows during opponent turn.
##
## Emits: unit_tapped
func tap_backline_unit(player: int, card) -> bool:
	var zone: String = get_unit_current_zone(player, card)
	if zone != ZONE_BACKLINE:
		push_error("ZoneManager.tap_backline_unit: Card is not in backline")
		return false
	
	if card in _tapped_units[player]:
		push_warning("ZoneManager.tap_backline_unit: Card already tapped")
		return false
	
	_tapped_units[player].append(card)
	emit_signal("unit_tapped", player, card)
	return true
#endregion

#region PUBLIC API - ZONE QUERIES
## Returns a copy of the zone contents array — never the reference.
func get_zone_contents(player: int, zone: String) -> Array:
	if not _zones.has(player):
		push_error("ZoneManager.get_zone_contents: Invalid player %d" % player)
		return []
	if not _zones[player].has(zone):
		push_error("ZoneManager.get_zone_contents: Invalid zone %s" % zone)
		return []
	return _zones[player][zone].duplicate(true)

## Returns the rank of the active General (top of stack).
## Returns 0 if no General in stack.
func get_active_general_rank(player: int) -> int:
	if _general_stack[player].is_empty():
		return 0
	return _general_stack[player].back().rank

## Returns the active General card data.
func get_active_general(player: int) : :
	if _general_stack[player].is_empty():
		return null
	return _general_stack[player].back()

## Returns current zone for a card, or empty string if not found.
func get_unit_current_zone(player: int, card) -> String:
	for zone_name in [ZONE_FRONTLINE, ZONE_BACKLINE, ZONE_SHIELD, ZONE_ENERGY, ZONE_REMnant]:
		if card in _zones[player][zone_name]:
			return zone_name
	return ""

## Returns the paired frontline CardData for a backline slot index.
## Returns null if no unit in that frontline slot.
func get_paired_frontline_slot(player: int, backline_index: int) : :
	var frontline: Array = _zones[player][ZONE_FRONTLINE]
	if backline_index < 0 or backline_index >= frontline.size():
		return null
	return frontline[backline_index]
#endregion

#region VALIDATION HELPERS
## Returns true if the zone is at capacity.
func is_zone_full(player: int, zone: String) -> bool:
	match zone:
		ZONE_FRONTLINE:
			return _zones[player][ZONE_FRONTLINE].size() >= MAX_FRONTLINE
		ZONE_BACKLINE:
			return _zones[player][ZONE_BACKLINE].size() >= MAX_BACKLINE
		ZONE_SHIELD:
			return _zones[player][ZONE_SHIELD].size() >= MAX_SHIELD
		ZONE_COMMAND:
			return false
		_:
			return false

## Returns true if the zone is a legal deploy target.
## frontline and backline only — command_zone and rift_zone are never legal.
func is_legal_deploy_target(zone: String) -> bool:
	return zone == ZONE_FRONTLINE or zone == ZONE_BACKLINE

## Returns true if the card has the specified keyword.
func has_keyword(card, keyword: String) -> bool:
	return card != null and card.has_keyword(keyword)

## Returns true if card is in deployed_this_turn.
func is_deployed_this_turn(player: int, card) -> bool:
	return card in _deployed_this_turn[player]

## Returns true if card is tapped in backline.
func is_tapped_in_backline(player: int, card) -> bool:
	return card in _tapped_units[player]
#endregion

#region INITIALIZATION
## Initializes a player's General at Rank 1.
func initialize_general(player: int, card) -> void:
	if not _general_stack[player].is_empty():
		push_warning("ZoneManager.initialize_general: Overwriting existing General stack for player %d" % player)
	_general_stack[player].clear()
	_general_stack[player].append(card)
	_zones[player][ZONE_COMMAND].append(card)

## Clears deployed_this_turn tracking at turn start.
func clear_deployed_this_turn(player: int) -> void:
	_deployed_this_turn[player].clear()

## Returns the count of face-up Energy cards for a player.
func get_energy_count(player: int) -> int:
	return _zones[player][ZONE_ENERGY].size()

## Returns the count of shields remaining for a player.
func get_shield_count(player: int) -> int:
	return _zones[player][ZONE_SHIELD].size()

## Returns the active Rift card.
func get_active_rift() : :
	return _active_rift

## Returns a copy of the General stack.
func get_general_stack(player: int) -> Array:
	return _general_stack[player].duplicate(true)

## Returns a copy of the legacy abilities array.
func get_legacy_abilities(player: int) -> Array:
	return _legacy_abilities[player].duplicate(true)

## Returns a copy of the devoured cards array.
func get_devoured_cards(player: int) -> Array:
	return _devoured_cards[player].duplicate(true)
#endregion