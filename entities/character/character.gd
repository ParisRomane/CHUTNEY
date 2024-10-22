class_name Player
extends CharacterBody2D

# MAX_SPEED is a constant!!! (since we cannot export constant in GDScript)
@export var MAX_SPEED : float = 1000.0
@export var thruster_power : float = 100.0
# TEMPORARY!!! In future we probably want to use the bounce factor of the collider, not the character.
@export var bounce_force : float = 0.5
@export var ship : CharacterBody2D 
@export var max_fuel : float

var longueur_corde : int = 4500

var bounce_force_store : float = 0.5

var can_shoot: bool = true

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
var current_fuel : float
var is_hit : bool = false
var resist_hazard: Array[bool] = [
	true, false, false, false
]

func _ready() -> void:
	inventory = Ressource.new(0,0,0)
	current_fuel = max_fuel
	var ship_pos : Vector2 = ship.get_node("CollectArea").position
	reset_path(ship_pos)
	bounce_force_store = bounce_force

func gather_inputs() -> void:
	mouse_pos = get_global_mouse_position()
	shoot_line = mouse_pos - global_position

func _can_shoot() -> void:
	can_shoot = true

func _cannot_shoot() -> void:
	can_shoot = false
	
func _physics_process(delta: float) -> void:
	
	gather_inputs()
	animate()
	
	# Turn and apply a force to the character
	look_at(mouse_pos)
	if can_shoot and Input.is_action_pressed("shoot") and can_move and current_fuel >= 0.0:
		velocity -= shoot_line * thruster_power
		current_fuel -= 5
	
	if Input.is_action_just_pressed("ui_accept"):
		can_move = false
		going_back = true
		next_pos = get_next_pos()
	
	if going_back:
		
		if (next_pos - position).length_squared() < 100:
			next_pos = get_next_pos()

		velocity = (next_pos - position).normalized() * MAX_SPEED
	
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
		
	# Damage handling
	if is_hit:
		current_fuel -= 1.0

func get_next_pos() -> Vector2:
	var path : Path2D = get_parent()
	var size : int = path.get_size()
	var next : Vector2
	var line : Line2D = get_parent().get_child(0)
	
	if size != 0:
		next = get_parent().curve.get_point_position(size-1)
		get_parent().curve.remove_point(size-1)
		line.remove_point(size-1)
	
	else:
		going_back = false
		can_move = true
		# Center the player and reset the path origin
		var ship_pos : Vector2 = ship.get_node("CollectArea").position
		reset_path(ship_pos)
		next = ship_pos
		
	return next

func animate() -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		$BodyAnimationTree.set("parameters/conditions/firing", true)
		$AnimatedSpriteExtinguisher.visible = true
	else:
		$BodyAnimationTree.set("parameters/conditions/firing", false)
		$AnimatedSpriteExtinguisher.visible = false
	
	if !can_move:
		$BodyAnimationTree.set("parameters/conditions/rope_active", true)
		$BodyAnimationTree.set("parameters/conditions/rope_inactive", false)
	else:
		$BodyAnimationTree.set("parameters/conditions/rope_active", false)
		$BodyAnimationTree.set("parameters/conditions/rope_inactive", true)
	
func rope_end() -> void:
	velocity -= velocity * 1.01
	can_move = false
	
func collect(ressource : Ressource) -> void:
	inventory.add(ressource)

func reset_path(pos: Vector2) -> void:
	position = pos
	get_parent().curve.add_point(pos)
	get_parent().get_child(0).add_point(pos)

func hit(value : bool) -> void:
	is_hit = value

func enter_ship() -> void:
	bounce_force = 0.1

func exit_ship() -> void:
	bounce_force = bounce_force_store
