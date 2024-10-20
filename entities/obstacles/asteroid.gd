extends StaticBody2D
var sprite: Sprite2D
static var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $Sprite2D
	var spr : int = rng.randi_range(0, 2)
	if spr == 0:
		sprite.texture = load("res://assets/images/asteroid_0.svg")
	elif spr == 1:
		sprite.texture = load("res://assets/images/asteroid_1.svg")
	elif spr == 2:
		sprite.texture = load("res://assets/images/asteroid_2.svg")
	
	sprite.rotation_degrees = rng.randi_range(0,360)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)-> void:
	pass
