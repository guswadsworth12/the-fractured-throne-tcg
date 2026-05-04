class_name UnitCard
extends res://src/cards/card_data.gd

@export var power: int = 0
@export var current_power: int = 0
@export var unit_subtype: String = ""
@export var is_general_eligible: bool = false
@export var frontline_ability: String = ""
@export var backline_ability: String = ""
@export var command_ability: String = ""
@export var surge_ability: String = ""
@export var active_zone: String = "backline"
@export var is_tapped: bool = false
@export var deployed_this_turn: bool = false
@export var reanimate_removed: bool = false
@export var augments: Array = []
@export var bloodlust_stacks: int = 0
@export var is_general: bool = false
@export var is_devoured: bool = false
@export var drakesworn_partner_id: int = -1

func from_dict(row: Dictionary) -> UnitCard:
	super.from_dict(row)
	power = row.get("power", 0)
	current_power = power
	unit_subtype = row.get("unit_subtype", "")
	is_general_eligible = row.get("is_general_eligible", false)
	frontline_ability = row.get("frontline_ability", "")
	backline_ability = row.get("backline_ability", "")
	command_ability = row.get("command_ability", "")
	is_tapped = false
	deployed_this_turn = false
	reanimate_removed = false
	augments = []
	bloodlust_stacks = 0
	is_general = false
	is_devoured = false
	drakesworn_partner_id = -1
	if has_keyword("Surge"):
		surge_ability = backline_ability
	return self

func get_active_ability() -> String:
	match active_zone:
		"frontline":
			return frontline_ability if frontline_ability else ""
		"backline":
			return backline_ability if backline_ability else ""
		"command":
			return command_ability if command_ability else ""
		_:
			return ""

func has_ability_in_zone(zone: String) -> bool:
	match zone:
		"frontline":
			return frontline_ability != null and frontline_ability != ""
		"backline":
			return backline_ability != null and backline_ability != ""
		"command":
			return command_ability != null and command_ability != ""
		_:
			return false

func get_rank_label() -> String:
	return "Rank " + str(rank_cost)

func is_within_power_cap() -> bool:
	var caps = {1: 400, 2: 650, 3: 900, 4: 1300}
	return power <= caps.get(rank_cost, 0)

func get_ability_tax_estimate() -> int:
	var filled = 0
	if has_ability_in_zone("frontline"):
		filled += 1
	if has_ability_in_zone("backline"):
		filled += 1
	if has_ability_in_zone("command"):
		filled += 1
	match filled:
		0:
			return 0
		1:
			return 50
		2:
			return 150
		3:
			return 200
		_:
			return 0