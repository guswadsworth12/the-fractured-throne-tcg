extends Node

## TurnManager.gd
## Manages the 7-phase turn structure and game state for The Fractured Throne TCG.
## Communicates via signals only and avoids direct calls to other singletons.

# -- ENUMS --

enum Phase {
	UNTAP,
	DRAW,
	ADVANCE,
	DEPLOY,
	MOVE,
	BACKLINE_ACT,
	FRONTLINE_ACT,
	END
}

# -- SIGNALS --

# Core Phase Signals
signal phase_changed(phase: Phase)
signal turn_started(player: String, turn_number: int)
signal turn_ended(player: String)

# Action Requests
signal draw_requested(count: int)
signal singularity_triggered()
signal advance_requested()
signal deploy_requested(slots_remaining: int)
signal move_requested()
signal action_phase_started(zone: String)
signal end_phase_started()

# Reaction/Burst Windows
signal burst_window_opened()
signal burst_window_closed()

# External Input Signals (To be emitted by other managers/UI)
signal player_action_confirmed(action_type: String, data: Dictionary)
signal external_process_completed(process_name: String, result: Dictionary)

# -- STATE VARIABLES --

var active_player: String = "player_one"
var current_phase: Phase = Phase.UNTAP
var turn_number: int = 1

# Per-turn tracking
var deploy_count: int = 0
var has_moved: bool = false
var has_advanced: bool = false
var has_used_burst_cast: bool = false
var has_used_augment: bool = false
var first_turn: bool = true # Resets after Player One's first Draw phase

# Tracking for Blitz/Move rules
var newly_deployed_units: Array = []

# -- INITIALIZATION --

func _ready() -> void:
	## Note: Game initialization should call start_game()
	pass

## Begins the game for a specific player.
func start_game(starting_player: String = "player_one") -> void:
	active_player = starting_player
	turn_number = 1
	first_turn = true
	start_turn(active_player)

## Initializes all per-turn state and begins Phase 0 (UNTAP).
func start_turn(player: String) -> void:
	active_player = player
	deploy_count = 0
	has_moved = false
	has_advanced = false
	has_used_burst_cast = false
	has_used_augment = false
	newly_deployed_units.clear()
	
	emit turn_started(active_player, turn_number)
	phase_untap()

# -- PHASE LOGIC --

## Phase 0: UNTAP
## Signals ZoneManager to untap backline units.
## Awaits: "untap_completed" from ZoneManager via external_process_completed signal.
func phase_untap() -> void:
	current_phase = Phase.UNTAP
	emit phase_changed(current_phase)
	
	# Signal ZoneManager to untap all tapped Backline units
	emit action_phase_started("untap_backline")
	
	# Await confirmation from ZoneManager or global event bus
	await external_process_completed
	
	phase_draw()

## Phase 1: DRAW
## Requests 2 cards. Handles First Turn skip for Player One.
## Handles Singularity if deck is empty.
## Awaits: "draw_completed" or "reshuffle_completed" via external_process_completed.
func phase_draw() -> void:
	current_phase = Phase.DRAW
	emit phase_changed(current_phase)
	
	# First turn rule: player_one skips Draw Phase on Turn 1 only
	if first_turn and active_player == "player_one":
		first_turn = false # Reset flag after skip
		phase_advance()
		return
	
	await _perform_draw(2)
	phase_advance()

## Internal helper for draw logic including Singularity.
func _perform_draw(count: int) -> void:
	emit draw_requested(count)
	var result = await external_process_completed
	
	# If deck empty mid-draw: emit singularity_triggered, await reshuffle
	if result.get("deck_empty", false) and result.get("remaining", 0) > 0:
		emit singularity_triggered()
		await external_process_completed # Await reshuffle_completed
		await _perform_draw(result.get("remaining", 0)) # Recursive draw for remaining

## Phase 2: ADVANCE
## Player may move a unit from Backline to Frontline.
## Awaits: player_action_confirmed (confirm or skip).
func phase_advance() -> void:
	current_phase = Phase.ADVANCE
	emit phase_changed(current_phase)
	
	emit advance_requested()
	
	var input = await player_action_confirmed
	if input.action_type == "advance":
		has_advanced = true
	
	phase_deploy()

## Phase 3: DEPLOY
## Allow up to 2 deploys. Reaction window (Burst) is open.
## Handles Devour (slot-free deploy).
## Awaits: player_action_confirmed (deploy, devour, or pass).
func phase_deploy() -> void:
	current_phase = Phase.DEPLOY
	emit phase_changed(current_phase)
	emit burst_window_opened()
	
	while deploy_count < 2:
		emit deploy_requested(2 - deploy_count)
		var input = await player_action_confirmed
		
		if input.action_type == "deploy":
			deploy_count += 1
			newly_deployed_units.append(input.data.get("unit_id"))
		elif input.action_type == "devour":
			# Devour does not consume a deploy slot
			emit action_phase_started("devour")
			await external_process_completed
		elif input.action_type == "pass":
			break
	
	phase_move()

## Phase 4: MOVE
## Allow one unit move. Deployed units this turn cannot move.
## Awaits: player_action_confirmed (move or skip).
func phase_move() -> void:
	current_phase = Phase.MOVE
	emit phase_changed(current_phase)
	
	emit move_requested()
	
	var input = await player_action_confirmed
	if input.action_type == "move":
		# Logic check: input.data.unit_id should not be in newly_deployed_units
		has_moved = true
	
	phase_backline_act()

## Phase 5A: BACKLINE ACTION
## Units in backline may boost or use abilities.
## Awaits: player_action_confirmed (final pass).
func phase_backline_act() -> void:
	current_phase = Phase.BACKLINE_ACT
	emit phase_changed(current_phase)
	emit action_phase_started("backline")
	
	# Per-unit input handled by UI/Action managers. TurnManager awaits final pass.
	await player_action_confirmed
	phase_frontline_act()

## Phase 5B: FRONTLINE ACTION
## Units in frontline may attack, defend, or use abilities.
## Accounts for Blitz (deployed this turn units can act).
## Awaits: player_action_confirmed (final pass).
func phase_frontline_act() -> void:
	current_phase = Phase.FRONTLINE_ACT
	emit phase_changed(current_phase)
	emit action_phase_started("frontline")
	
	# Note: newly_deployed_units with Blitz are eligible.
	# CombatResolver or KeywordHandler listens for attack_declared signals.
	
	await player_action_confirmed
	phase_end()

## Phase 6: END
## Cleanup per-turn flags, resolve Rift effects, swap players.
## Awaits: discard check and rift resolution via external_process_completed.
func phase_end() -> void:
	current_phase = Phase.END
	emit phase_changed(current_phase)
	emit end_phase_started()
	emit burst_window_closed()
	
	# Hand discard check (limit 7)
	emit action_phase_started("hand_discard_check")
	await external_process_completed
	
	# Rift end-of-turn resolution
	emit action_phase_started("rift_resolution")
	await external_process_completed
	
	# Cleanup
	_finalize_turn()

func _finalize_turn() -> void:
	var old_player = active_player
	
	# Increment turn number if player two just finished
	if active_player == "player_two":
		turn_number += 1
	
	# Swap player
	active_player = "player_one" if active_player == "player_two" else "player_two"
	
	emit turn_ended(old_player)
	
	# Begin next turn
	start_turn(active_player)

# -- UTILITIES --

func is_phase(phase: Phase) -> bool:
	return current_phase == phase

func get_phase_name() -> String:
	return Phase.keys()[current_phase]