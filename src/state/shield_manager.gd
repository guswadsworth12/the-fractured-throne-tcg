class_name ShieldManager
extends Node

# Tracks Shield Zone — max 6 face-down cards, never reshuffled into Singularity

signal shield_broken(shield_card: Object, breaker: Object)
signal shield_added(card: Object)
signal shields_reset()

var shield_cards: Array = []
var max_shields: int = 6

func _ready() -> void:
	pass

func add_shield(card: Object) -> bool:
	# TODO: Add face-down card, enforce max 6
	return false

func break_shield(index: int, breaker: Object) -> Object:
	# TODO: Remove and return shield card at index, emit shield_broken signal
	return null

func get_shield_count() -> int:
	return shield_cards.size()

func is_full() -> bool:
	return shield_cards.size() >= max_shields

func reset_shields() -> void:
	# TODO: Called during game start / reset — clear all shields (they go to remnant, not Singularity)
	shields_reset.emit()