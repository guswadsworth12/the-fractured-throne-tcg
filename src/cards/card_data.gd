class_name CardData
extends Resource

@export var id: int = 0
@export var name: String = ""
@export var faction_name: String = ""
@export var faction_id: int = 0
@export var card_type: String = ""
@export var rank_cost: int = 1
@export var is_unique: bool = false
@export var copy_limit: int = 3
@export var flavor_text: String = ""
@export var set_code: String = ""
@export var art_path: String = ""
@export var notes: String = ""
@export var keywords: Array[String] = []
@export var power_cap_ok: bool = false

func from_dict(row: Dictionary) -> CardData:
	id = row.get("id", 0)
	name = row.get("name", "")
	faction_name = row.get("faction_name", "")
	faction_id = row.get("faction_id", 0)
	card_type = row.get("card_type", "")
	rank_cost = row.get("rank_cost", 1)
	is_unique = row.get("is_unique", false)
	copy_limit = row.get("copy_limit", 3)
	flavor_text = row.get("flavor_text", "")
	set_code = row.get("set_code", "")
	art_path = row.get("art_path", "")
	notes = row.get("notes", "")
	power_cap_ok = row.get("power_cap_ok", false)
	
	var kw_raw = row.get("keywords", "")
	if kw_raw is String and kw_raw != "":
		keywords = Array(kw_raw.split(",", false), TYPE_STRING, "", null)
	elif kw_raw is Array:
		keywords = Array(kw_raw, TYPE_STRING, "", null)
	else:
		keywords = []
	
	return self

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"faction_name": faction_name,
		"faction_id": faction_id,
		"card_type": card_type,
		"rank_cost": rank_cost,
		"is_unique": is_unique,
		"copy_limit": copy_limit,
		"flavor_text": flavor_text,
		"set_code": set_code,
		"art_path": art_path,
		"notes": notes,
		"keywords": keywords,
		"power_cap_ok": power_cap_ok
	}

func has_keyword(keyword: String) -> bool:
	return keywords.any(func(k): return k.to_lower() == keyword.to_lower())

func get_display_name() -> String:
	if is_unique:
		return "[UNIQUE] " + name
	return name