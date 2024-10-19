class_name Player
extends Node

var ressources: Ressource = Ressource.new(0,0,0)
var craft_multiplier: int = 0
var max_fuel: int
var friction: int
var view_radius: int
var resist_hazard: Array[bool] = [
	false, false, false
]

func _ready() -> void:
	pass
	
