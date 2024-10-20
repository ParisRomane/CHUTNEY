class_name Ship
extends CharacterBody2D

var inventory : Ressource
var _multiplier : int = 0
var _craft_tier: Dictionary = {
	"cc_set_zipline_length": 0,
	"cc_set_fuel_capacity": 0,
	"cc_set_player_friction": 0,
	"cc_set_player_view": 0,
	"cc_set_ship_view": 0,
	"cc_set_hazard_protection": 0
}
var _crafts: Dictionary = {
	"cc_set_zipline_length": [null, null, null],
	"cc_set_fuel_capacity": [null, null, null],
	"cc_set_player_friction": [null, null, null],
	"cc_set_player_view": [null, null, null],
	"cc_set_ship_view": [null, null, null],
	"cc_set_hazard_protection": [null, null, null],
}

func _ready() -> void:
	Craft.ship = self
	Craft.player = null # caracter
	_load_crafts()
	inventory = Ressource.new(0,0,0)

func _on_collect_area_body_entered(body: Node2D) -> void:
	
	if body.has_method("collect"):
		inventory.add_with_multiplier(body.inventory, _multiplier)
		body.inventory.reset()

func _load_crafts() -> void:
	var crafts: Array[Craft] = Craft.from_json("./globals/craft/craft_definition.json")
	for craft in crafts:
		_crafts[craft.effect_name][craft.tier] = craft
	
