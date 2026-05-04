## CardData.gd
## Flat card data class for The Fracture Throne TCG.
## Used across all engine signals and scenes.
## **Type-specific fields**: treat as read-only based on card_type.

class_name CardData

#region SHARED FIELDS
var id: String = ""
var name: String = ""
var faction_name: String = ""
var card_type: String = "Unit" ## "Unit", "Burst", "Augment", "Rift"
var rank_cost: int = 0
var is_unique: bool = false
var copy_limit: int = 3

## Shared across unit/burst/augment/rift
var keywords: Array = [] ## Array[string]
var flavor_text: String = ""
var set_code: String = "SET1"
var art_path: String = ""
#endregion

#region TYPE-SPECIFIC FIELDS — Unit/Burst/Augment/Rift
## Unit cards — mandatory if card_type="Unit"
var power: int = 0
var unit_subtype: String = "" ## "General", "Frontline", "Backline", ""
var frontline_ability: String = ""
var backline_ability: String = ""
var command_ability: String = ""
var is_general_eligible: bool = false

## Burst cards
var burst_subtype: String = "" ## "Reaction", "Fast", "Slow"
var effect_text: String = ""

## Augment cards
var augment_subtype: String = "" ## "Artifact", "Enchantment", "Equipment"

## Shared between Burst, Augment, Rift
## Rift
#endregion

#region METHODS
func _init(p_id: String = "", 
 p_name: String = "", 
 p_faction_name: String = "",
 p_card_type: String = "Unit", 
 p_rank_cost: int = 0) -> void:
 id = p_id
 name = p_name
 faction_name = p_faction_name
 card_type = p_card_type ## One of "Unit", "Burst", "Augment", "Rift"
 rank_cost = p_rank_cost

func has_keyword(kw: String) -> bool:
 return kw in keywords

## Zones this card can normally occupy:
## Unit → "frontline", "backline"
## Augment → none (attached or deployed via abilities)
## Rift → command_zone
## Burst → none (momentary)
func get_allowed_zones() -> Array:
 match card_type:
 "Unit":
 if unit_subtype == "General":
 return ["command_zone"]
 return ["frontline", "backline"]
 "Augment":
 return []
 "Burst":
 return []
 "Rift":
 return ["command_zone"]

## Whether this card counts against frontline/backline limits:
## General → false
## Frontline Unit → frontline limit
## Backline Unit → backline limit
## Burst/Augment → false (typically in command_zone)
## Rift → command_zone only — does not count
func counts_against_zone_limit(zone: String) -> bool:
 match card_type:
 "Unit":
 match zone:
 "frontline":
 return unit_subtype != "General"
 "backline":
 return unit_subtype != "General" and frontline_ability == ""
 "command_zone":
 return unit_subtype == "General"
 else:
 return false
 "Burst":
 return false
 "Augment":
 return false
 "Rift":
 return zone == "command_zone"
#endregion