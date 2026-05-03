class_name DeckValidator
extends Node

# Validates deck against construction rules:
# - Mono-faction only (Set 1)
# - Max copies per card
# - Rank/power constraints checked via balance_check view
# - General deck size limits

var max_copies_per_card: int = 3
var min_deck_size: int = 40
var max_deck_size: int = 60

func _ready() -> void:
	pass

func validate(deck_cards: Array) -> Dictionary:
	# TODO: Return {valid: bool, errors: [], warnings: []}
	return {"valid": true, "errors": [], "warnings": []}

func check_balance_constraints(deck_cards: Array) -> Array:
	# TODO: Query balance_check view for each card
	# Return list of violations
	return []

func check_faction_purity(deck_cards: Array) -> bool:
	# TODO: Set 1 mono-faction only — all cards must share one faction
	return true

func check_max_copies(card_id: int, deck_cards: Array) -> bool:
	# TODO: Enforce max_copies_per_card
	return true