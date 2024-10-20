class_name Craft

var name: String
var tier: int
var cost: Ressource
var effect_name: StringName
var arg: int
var description_short: String
var description: String
var done: bool = false # only relevant for objectives

static var ship: Ship
static var player: Player

func _init(name_: String, tier_: int, cost_: Ressource, description_short_: String, description_: String, effect_: StringName, arg_: int) -> void:
	self.name = name_
	self.tier = tier_
	self.cost = cost_
	self.description_short = description_short_
	self.description = description_
	self.effect_name = effect_
	self.arg = arg_
	
static func make_objective(name_: String, cost_: Ressource) -> Craft:
	return Craft.new(
		name_, # name
		0, # tier
		cost_, # cost
		"", # description_short
		"", # description
		"", # callback_name
		0 # callback_arg
	)
	
static func from_json(path: String) -> Array[Craft]:
	var json_as_text: String = FileAccess.get_file_as_string(path)
	var json: Array[Variant] = JSON.parse_string(json_as_text)
	var result: Array[Craft] = []
	for craft: Variant in json:
		var _name: String = craft["name"]
		var _tier: int = craft["tier"]
		var _ressource: Dictionary = craft["cost"]
		var _cost: Ressource = Ressource.new(
			_ressource["organic"],
			_ressource["scrap"],
			_ressource["electronic"]
		)
		var _description_short: String = craft["description_short"]
		var _description: String = craft["description"]
		var _effect: StringName = craft["effect"]
		var _arg: int = craft["arg"]
		result.append(Craft.new(
			_name, _tier, _cost, _description_short, _description, _effect, _arg
		))
	return result
	
func make() -> bool: # replace object with ship class
	if ship.ressources.have_at_least(cost):
		ship.ressources.remove(cost)
		var effect: Callable = Callable(self, effect_name)
		effect.call(arg)
		return true
	return false

# extend_craft_capacity
func cc_set_craft_multiplier(amount: int) -> void:
	ship.craft_multiplier = amount
	
# extend_zip_line
func cc_set_zipline_length(length: int) -> void:
	ship.zipline_length = length

# extend_fuel_capacity
func cc_set_fuel_capacity(max_capacity: int) -> void:
	player.max_fuel = max_capacity
	
# extend_speed
func cc_set_player_friction(friction: int) -> void:
	player.friction = friction
	
# extend_view
func cc_set_player_view(radius: int) -> void:
	player.view_radius = radius
	
func cc_set_ship_view(radius: int) -> void:
	ship.view_radius = radius

# prevent_hazard
func cc_set_hazard_protection(kind: int) -> void:
	player.resist_hazard[kind] = true
	
func cc_objective_done(ignored: int) -> void:
	done = true
