class_name KeywordRegistry
extends Node

# Maps keyword names to handler class names or instances

var _registry: Dictionary = {}

func _ready() -> void:
	_register_keywords()

func _register_keywords() -> void:
	_registry["Bloodlust"] = "KeywordHandler"
	_registry["Drunken Rage"] = "KeywordHandler"
	_registry["Void Pulse"] = "KeywordHandler"
	_registry["Sovereign's Reign"] = "KeywordHandler"
	_registry["Legacy"] = "KeywordHandler"
	_registry["Surge"] = "KeywordHandler"
	_registry["Reanimate"] = "KeywordHandler"
	_registry["Dragonfire"] = "KeywordHandler"
	_registry["Blitz"] = "KeywordHandler"
	_registry["Sentinel"] = "KeywordHandler"
	_registry["Aegis"] = "KeywordHandler"
	_registry["Pierce"] = "KeywordHandler"
	_registry["Infiltrate"] = "KeywordHandler"
	_registry["Lifesteal"] = "KeywordHandler"
	_registry["Anchor"] = "KeywordHandler"

func get_handler(keyword: String) -> String:
	return _registry.get(keyword, "")

func is_registered(keyword: String) -> bool:
	return keyword in _registry

func get_all_keywords() -> Array:
	return _registry.keys()