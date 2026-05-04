## ShieldManager.gd
## Manages Shield state for The Fracture Throne TCG.
## Godot 4 Autoload singleton using GDScript 4 only.
## Communication via signals only — no direct calls to other singletons.
## Listens to ZoneManager, EnergyManager, and TurnManager signals.
## Never modifies zone contents directly — emits signals for ZoneManager.
## Never modifies Energy directly — emits signals for EnergyManager.
## Scenes read Shield state from this singleton — never write to it.

extends Node

class_name ShieldManager

#region RESOLUTION ORDER
## SHIELD BREAK RESOLUTION ORDER (per attack):
##   1. Shield breaks (ZoneManager.break_shield → shield_broken signal)
##   2. Surge triggers if applicable (from ZoneManager's surge_triggered)
##   3. Lifesteal triggers if attacker has Lifesteal (not from Pierce-caused break)
##   4. Pierce triggers if attacker has Pierce
##     4a. Pierce break resolves (second shield_broken)
##     4b. Lifesteal does NOT trigger on Pierce break
##   5. Oathstrike check (if defending player chose zero defenders)
##   6. Radiant Lattice recalculates
##   7. Blood Tithe increments (handled by EnergyManager)
## CRITICAL: Pierce triggers ONCE per attack only
## CRITICAL: Lifesteal does NOT trigger on Pierce-caused breaks
## CRITICAL: Oathstrike requires zero defenders — not just any kill
## CRITICAL: Oathstrike does NOT trigger on Infiltrate attacks
## CRITICAL: Radiant Lattice max bonus is +400 regardless of Shield count
## CRITICAL: Shields never go to remnant_zone directly — always energy_zone
## CRITICAL: Shields are never reshuffled into Singularity
## CRITICAL: Shield Zone hard cap is 6 — Oathstrike fails silently if at 6
#endregion

#region SIGNALS EMITTED
signal shield_broken(player: int, card, shields_remaining: int)
signal shields_depleted(player: int)
signal surge_triggered(player: int, card)
signal pierce_shield_broken(target_player: int, attacker)
signal lifesteal_triggered(attacking_player: int, attacker, target_player: int)
signal oathstrike_triggered(player: int, card)
signal radiant_barrier_activated(player: int, card, energy_cost: int)
signal warden_light_activated(player: int)
signal radiant_lattice_updated(player: int, bonus: int)
signal upwelling_triggered(player: int, card)
signal shields_this_turn_updated(player: int, count: int)
signal tidal_veil_redirected(player: int, card, target_card)
signal warden_light_expired(player: int)
#endregion

#region STATE
var shields_remaining: Dictionary = {0: 6, 1: 6}
var shields_broken_this_turn: Dictionary = {0: 0, 1: 0}
var pierce_triggered_this_attack: bool = false
var shield_contents: Dictionary = {0: [], 1: []}
#endregion


#region SIGNAL CONNECTION SETUP
func _ready() -> void:
	_connect_to_zone_manager()
	_connect_to_energy_manager()
	_connect_to_turn_manager()

func _connect_to_zone_manager() -> void:
	call_deferred("_delayed_zone_manager_connect")

func _delayed_zone_manager_connect() -> void:
	if not has_node("/root/ZoneManager"):
		return
	var zm = get_node("/root/ZoneManager")
	if zm.has_signal("shield_broken"):
		zm.shield_broken.connect(_on_zone_shield_broken)
	if zm.has_signal("unit_destroyed"):
		zm.unit_destroyed.connect(_on_zone_unit_destroyed)
	if zm.has_signal("zone_changed"):
		zm.zone_changed.connect(_on_zone_changed)

func _connect_to_energy_manager() -> void:
	call_deferred("_delayed_energy_manager_connect")

func _delayed_energy_manager_connect() -> void:
	if not has_node("/root/EnergyManager"):
		return
	var em = get_node("/root/EnergyManager")
	if em.has_signal("energy_spent"):
		em.energy_spent.connect(_on_energy_spent)

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
		tm.attack_declared.connect(_on_attack_declared)
#endregion

#region ZONE MANAGER SIGNAL HANDLERS
func _on_zone_shield_broken(player: int, card, remaining: int) -> void:
	shields_remaining[player] = maxi(0, remaining)
	shields_broken_this_turn[player] += 1
	emit_signal("shields_this_turn_updated", player, shields_broken_this_turn[player])
	if card.has_keyword("Surge"):
		emit_signal("surge_triggered", player, card)
	emit_signal("shield_broken", player, card, shields_remaining[player])
	if shields_remaining[player] == 0:
		emit_signal("shields_depleted", player)
	recalculate_radiant_lattice(player)

func _on_zone_unit_destroyed(_player: int, _card, _zone: String) -> void:
	pass

func _on_zone_changed(player: int, zone_name: String, _contents: Array) -> void:
	if zone_name == "shield_zone":
		recalculate_radiant_lattice(player)
#endregion

#region ENERGY MANAGER SIGNAL HANDLERS
func _on_energy_spent(_player: int, _amount: int) -> void:
	pass
#endregion

#region TURN MANAGER SIGNAL HANDLERS
func _on_phase_changed(_old_phase: int, new_phase: int) -> void:
	if new_phase == 0:
		reset_pierce_flag()

func _on_end_phase_started() -> void:
	for p in [0, 1]:
		resolve_end_of_turn_shield_effects(p)

func _on_turn_ended(player: int) -> void:
	reset_turn_tracking(player)

func _on_attack_declared(_attacker, _defender) -> void:
	pierce_triggered_this_attack = false
#endregion

#region PUBLIC API - SHIELD OPERATIONS
func request_shield_break(player: int) -> bool:
	if shields_remaining[player] <= 0:
		return false
	return true

func resolve_pierce(attacker, target_player: int) -> void:
	if pierce_triggered_this_attack:
		return
	if shields_remaining[target_player] <= 0:
		return
	if not attacker.has_keyword("Pierce"):
		return
	pierce_triggered_this_attack = true
	emit_signal("pierce_shield_broken", target_player, attacker)
	if has_node("/root/ZoneManager"):
		get_node("/root/ZoneManager").break_shield(target_player)

func resolve_lifesteal(attacker, target_player: int, attacking_player: int) -> void:
	if not attacker.has_keyword("Lifesteal"):
		return
	emit_signal("lifesteal_triggered", attacking_player, attacker, target_player)

func resolve_oathstrike(player: int, card) -> void:
	if shields_remaining[player] >= 6:
		return
	if not card.has_keyword("Oathstrike"):
		return
	emit_signal("oathstrike_triggered", player, card)

func on_shield_added(player: int) -> void:
	shields_remaining[player] = mini(shields_remaining[player] + 1, 6)
	recalculate_radiant_lattice(player)

func resolve_radiant_barrier(player: int, card, energy_cost: int) -> void:
	emit_signal("radiant_barrier_activated", player, card, energy_cost)

func resolve_warden_light(player: int) -> void:
	emit_signal("warden_light_activated", player)

func recalculate_radiant_lattice(player: int) -> void:
	var face_down_count: int = shields_remaining[player]
	var bonus: int = mini(face_down_count * 100, 400)
	emit_signal("radiant_lattice_updated", player, bonus)

func resolve_upwelling(player: int, card) -> void:
	if shields_broken_this_turn[player] == 0:
		return
	if not card.has_keyword("Upwelling"):
		return
	emit_signal("upwelling_triggered", player, card)

func resolve_tidal_veil(player: int, card, target_card) -> void:
	emit_signal("tidal_veil_redirected", player, card, target_card)
#endregion

#region END OF TURN / RESET FUNCTIONS
func resolve_end_of_turn_shield_effects(player: int) -> void:
	emit_signal("warden_light_expired", player)
	recalculate_radiant_lattice(player)

func reset_pierce_flag() -> void:
	pierce_triggered_this_attack = false

func reset_turn_tracking(player: int) -> void:
	shields_broken_this_turn[player] = 0
	emit_signal("shields_this_turn_updated", player, 0)
	pierce_triggered_this_attack = false
#endregion

#region PUBLIC API - READ ONLY ACCESSORS
func get_shields_remaining(player: int) -> int:
	return shields_remaining.get(player, 0)

func get_shield_contents(player: int) -> Array:
	return shield_contents[player].duplicate(true) if shield_contents.has(player) else []

func get_shields_broken_this_turn(player: int) -> int:
	return shields_broken_this_turn.get(player, 0)
#endregion

#region INITIALIZATION
func initialize_player(player: int, initial_shields: Array) -> void:
	shields_remaining[player] = initial_shields.size()
	shield_contents[player] = initial_shields.duplicate(true)
	shields_broken_this_turn[player] = 0
	recalculate_radiant_lattice(player)
#endregion