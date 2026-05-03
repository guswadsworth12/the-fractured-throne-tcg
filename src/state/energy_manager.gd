class_name EnergyManager
extends Node

# Tracks the Energy Zone — face-up cards available to spend
# Energy is spent during deploy and ability costs

signal energy_changed(total: int)
signal energy_spent(amount: int)

var energy_cards: Array = []
var current_energy: int = 0

func _ready() -> void:
	pass

func add_energy_card(card: Object) -> void:
	# TODO: Add face-up card to energy zone, update total
	pass

func spend_energy(amount: int) -> bool:
	# TODO: Deduct energy, emit energy_spent, enforce non-negative
	return false

func get_total_energy() -> int:
	return current_energy

func get_energy_cards() -> Array:
	return energy_cards

func reset_for_turn() -> void:
	# TODO: Energy does not reset between turns (persistent zone)
	pass