class_name Ship
extends CharacterBody2D

var craft : Craft
@export var player : Player
var craft_button: Control
var inventory : Ressource
var _multiplier : int = 1
var _craft_tier: Dictionary = {
	"cc_set_craft_multiplier": 0,
	"cc_set_zipline_length": 0,
	"cc_set_fuel_capacity": 0,
	"cc_set_player_friction": 0,
	"cc_set_player_view": 0,
	"cc_set_ship_view": 0,
	"cc_set_hazard_protection": 0
}
var _crafts: Dictionary = {
	"cc_set_craft_multiplier": [null, null, null],
	"cc_set_zipline_length": [null, null, null],
	"cc_set_fuel_capacity": [null, null, null],
	"cc_set_player_friction": [null, null, null],
	"cc_set_player_view": [null, null, null],
	"cc_set_ship_view": [null, null, null],
	"cc_set_hazard_protection": [null, null, null],
}

func _ready() -> void:
	Craft.ship = self
	Craft.player = player # caracter
	_load_crafts()
	inventory = Ressource.new(0,0,0)

func _on_collect_area_body_entered(body: Node2D) -> void:
	
	if body.has_method("collect"):
		inventory.add_with_multiplier(body.inventory, _multiplier)
		body.inventory.reset()
		body.current_fuel = body.max_fuel

func _load_crafts() -> void:
	var crafts: Array[Craft] = Craft.from_json("./globals/crafts/craft_definition.json")
	for craft in crafts:
		_crafts[craft.effect_name][craft.tier] = craft
		

func _craft(nom_craft: Label, desc_craft:Label, short_craft:Label, button:Button, control:Control) -> void:
	var key : String = "cc_set_zipline_length"
	
	craft = _crafts[key][_craft_tier[key]]
	
	nom_craft.text = craft.name
	desc_craft.text = craft.description
	short_craft.text = craft.description_short
	button.pressed.connect(_launch_craft)
	craft_button = control

func _launch_craft()-> void:
	if craft.make():
		craft_button.flag = false
		craft_button.hide()
