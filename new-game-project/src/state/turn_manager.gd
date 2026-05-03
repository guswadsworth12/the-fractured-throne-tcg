extends Node

class_name TurnManager

signal phase_started(phase: int, subphase: int)
signal turn_started(player: int)
signal turn_ended(player: int)

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