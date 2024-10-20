class_name HUD
extends Control

@export var player : Player 
@export var ship : Ship 
var vide : ColorRect
var plein : ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vide = $RessourcesPlacement/Fuel/Vide
	plein = $RessourcesPlacement/Fuel/Plein
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	plein.size.y = player.current_fuel * .5
	vide.size.y = player.max_fuel * .5
	pass
