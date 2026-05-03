class_name FactionRegistry
extends Node

# Faction data lookup — 8 factions for Set 1

var _factions: Dictionary = {}

func _ready() -> void:
	_load_factions()

func _load_factions() -> void:
	_factions[1] = {"name": "Vampiric Hell", "theme": "Gothic horror / blood courts", "power_tendency": "High", "ability_tendency": "Low"}
	_factions[2] = {"name": "The Rot", "theme": "Undead swarm / attrition", "power_tendency": "Low", "ability_tendency": "High"}
	_factions[3] = {"name": "Data Kingdom", "theme": "Digital / network constructs", "power_tendency": "Low Frontline", "ability_tendency": "High Backline"}
	_factions[4] = {"name": "Radiant Shelter", "theme": "Magical / light and shields", "power_tendency": "Mid", "ability_tendency": "Mid"}
	_factions[5] = {"name": "Embercrown", "theme": "Dragon / volcanic", "power_tendency": "High", "ability_tendency": "Mid"}
	_factions[6] = {"name": "Voidborn Collective", "theme": "Deep space / control", "power_tendency": "Mid", "ability_tendency": "High"}
	_factions[7] = {"name": "Diamond League", "theme": "Interdimensional sports", "power_tendency": "Variable", "ability_tendency": "Chain abilities"}
	_factions[8] = {"name": "Gilded Syndicate", "theme": "1920s mob / casino", "power_tendency": "Variable", "ability_tendency": "Energy economy"}

func get_faction(faction_id: int) -> Dictionary:
	return _factions.get(faction_id, {})

func get_faction_name(faction_id: int) -> String:
	return _factions[faction_id].get("name", "Unknown")

func get_all_factions() -> Array:
	return _factions.values()