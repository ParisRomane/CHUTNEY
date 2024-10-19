class_name HUD
extends Control

@export var player : Character 
@export var ship : Ship 
var a : float = 0
var b : float = 0
var c : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	a += delta
	b+= delta
	c+= delta
	if roundi(a) % 3 == 2:
		player.inventory.organic += 2 
		player.inventory.electronic += 1
		a = 0
		
	if roundi(b) % 8 == 7:
		
		ship.inventory.organic += player.inventory.organic
		player.inventory.organic = 0
		ship.inventory.electronic += player.inventory.electronic
		player.inventory.electronic = 0
		b = 0
		a = -2
		
	if roundi(c) % 12 == 11:
		
		ship.inventory.organic -= 5
		ship.inventory.electronic -= 3
		c = 0
		b = 0
		a = -2
	pass
