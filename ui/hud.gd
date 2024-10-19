class_name HUD
extends Control

@export var player : Player 
@export var ship : Ship 
var a : float = 0
var b : float = 0
var c : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	ship = $Ship


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	a += delta
	b+= delta
	c+= delta
	if roundi(a) % 3 == 2:
		player.ressources.organic += 2 
		player.ressources.electronic += 1
		a = 0
		
	if roundi(b) % 8 == 7:
		
		ship.ressources.organic += player.ressources.organic
		player.ressources.organic = 0
		ship.ressources.electronic += player.ressources.electronic
		player.ressources.electronic = 0
		b = 0
		a = -2
		
	if roundi(c) % 12 == 11:
		
		ship.ressources.organic -= 5
		ship.ressources.electronic -= 3
		c = 0
		b = 0
		a = -2
	pass
