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
var can_move : bool = true
var going_back : bool = false
var next_pos := Vector2(0, 0)
var inventory : Ressource

func _ready() -> void:
	inventory = Ressource.new(0,0,0)

func gather_inputs() -> void:
	mouse_pos = get_global_mouse_position()
	shoot_line = mouse_pos - global_position

func _physics_process(delta: float) -> void:
	
	gather_inputs()
	
	# Turn and apply a force to the character
	look_at(mouse_pos)
	if Input.is_action_pressed("shoot") and can_move:
		velocity -= shoot_line * thruster_power
	
	if Input.is_action_just_pressed("ui_accept"):
		can_move = false
		going_back = true
	
	if going_back:
		var size : int = get_parent().get_size()
		if size !=1:
			next_pos = get_parent().curve.get_point_position(size-1)
		
					
			if (next_pos - position).length_squared() < 100:
				get_parent().curve.remove_point(size-1)
				get_parent().get_child(0).remove_point(size-1)

			velocity = (next_pos - position).normalized() * MAX_SPEED
		
		else:
			position = Vector2(0,0)
			velocity = Vector2(0,0)
			going_back = false
			can_move = true
	
	else:
		# Fake friction (actually there is no air in space)
		velocity.x = lerpf(velocity.x, 0, 0.01)
		velocity.y = lerpf(velocity.y, 0, 0.01)
		
		# Restrict the maximum of the vector length in order to avoid the case of a faster character in the corners.
		if velocity.length_squared() > MAX_SPEED**2:
			velocity = velocity.normalized() * MAX_SPEED
		
	var collision_info : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal()) * bounce_force
	
func rope_end() -> void:
	velocity -= velocity
	can_move = false
	
func collect(ressource : Ressource) -> void:
	print("COLLECTED !")
