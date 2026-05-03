class_name ZoneManager
extends Node

# Manages all 7 zones: frontline, backline, command_zone, rift_zone, shield_zone, energy_zone, remnant_zone

signal zone_changed(zone_name: String)

var zones: Dictionary = {
	"frontline": [],
	"backline": [],
	"command_zone": null,
	"rift_zone": null,
	"shield_zone": [],
	"energy_zone": [],
	"remnant_zone": []
}

var max_units: Dictionary = {
	"frontline": 4,
	"backline": 4,
	"command_zone": 1,
	"rift_zone": 1,
	"shield_zone": 6
}

func _ready() -> void:
	pass

func get_zone(zone_name: String) -> Array:
	return zones.get(zone_name, [])

func add_to_zone(zone_name: String, card: Object) -> bool:
	# TODO: Check capacity limits before adding
	return false

func remove_from_zone(zone_name: String, card: Object) -> bool:
	# TODO: Remove card from zone, return success
	return false

func is_zone_full(zone_name: String) -> bool:
	return false

func move_card(card: Object, from_zone: String, to_zone: String) -> bool:
	# TODO: Remove from source, add to destination, validate zone rules
	return false