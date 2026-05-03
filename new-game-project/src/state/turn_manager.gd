extends Node

class_name TurnManager

## Phase constants
const PHASE_UNIMPLEMENTED := -1
const PHASE_UNTAP := 0
const PHASE_DRAW := 1
const PHASE_REFRESH := 2
const PHASE_FIRSTMAIN := 3
const PHASE_COMBAT := 4
const PHASE_SECONDMAIN := 5
const PHASE_END := 6

signal phase_started(phase: int, subphase: int)
signal phase_changed(old_phase: int, new_phase: int)
signal end_phase_started()
signal attack_declared(attacker: CardData, defender: CardData)
signal turn_started(player: int)
signal turn_ended(player: int)

## Minimal CardData for TurnManager signals
class CardData:
	var id: String = ""
	var name: String = ""
	var rank: int = 0
	var faction: String = ""
	var power: int = 0
	var keywords: Array = []

var current_phase: int = 0
var current_subphase: int = 0
var current_player: int = 0

func _ready() -> void:
	pass

func start_game() -> void:
	current_phase = 0
	current_subphase = 0
	current_player = 0
	emit_signal("phase_started", current_phase, current_subphase)

func declare_attack(attacker: CardData, defender: CardData) -> void:
	emit_signal("attack_declared", attacker, defender)

func advance_phase() -> void:
	var old_phase := current_phase
	current_phase += 1
	if current_phase > PHASE_END:
		current_phase = PHASE_UNTAP
		current_player = 1 - current_player
		emit_signal("turn_ended", current_player)
		emit_signal("turn_started", current_player)
	emit_signal("phase_changed", old_phase, current_phase)
	emit_signal("phase_started", current_phase, current_subphase)
	if current_phase == PHASE_END:
		emit_signal("end_phase_started")