extends Node2D

static var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation_degrees = rng.randi_range(0,360)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)-> void:
	pass
