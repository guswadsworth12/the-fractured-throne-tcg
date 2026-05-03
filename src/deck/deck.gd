class_name Deck
extends Node

# Deck object — shuffle, draw, topdeck, zone management

var deck_cards: Array = []
var owner_id: int = 0

func _ready() -> void:
	pass

func build_from_card_ids(ids: Array) -> void:
	# TODO: Populate deck from list of card IDs
	pass

func shuffle() -> void:
	# TODO: Fisher-Yates shuffle
	pass

func draw(count: int = 1) -> Array:
	# TODO: Remove and return top N cards
	return []

func draw_one() -> Object:
	return null

func topdeck() -> Object:
	return null

func get_remaining_count() -> int:
	return deck_cards.size()

func is_empty() -> bool:
	return deck_cards.is_empty()