extends CharacterBody2D

# MAX_SPEED is a constant!!! (since we cannot export constant in GDScript)
@export var MAX_SPEED : float = 1000.0
@export var thruster_power : float = 100.0
# TEMPORARY!!! In future we probably want to use the bounce factor of the collider, not the character.
@export var bounce_force : float = 0.5

var up : float = 0.0
var down : float = 0.0
var left : float = 0.0
var right : float = 0.0
var mouse_pos := Vector2()
var shoot_line := Vector2()

func gather_inputs() -> void:
	mouse_pos = get_global_mouse_position()
	shoot_line = mouse_pos - global_position

func _physics_process(delta: float) -> void:
	
	gather_inputs()
	
	# Turn and apply a force to the character
	look_at(mouse_pos)
	if Input.is_action_pressed("shoot"):
		velocity -= shoot_line * thruster_power
	
	# Fake friction (actually there is no air in space)
	velocity.x = lerpf(velocity.x, 0, 0.01)
	velocity.y = lerpf(velocity.y, 0, 0.01)
	
	# Restrict the maximum of the vector length in order to avoid the case of a faster character in the corners.
	if velocity.length_squared() > MAX_SPEED**2:
		velocity = velocity.normalized() * MAX_SPEED
	
	var collision_info : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal()) * bounce_force
