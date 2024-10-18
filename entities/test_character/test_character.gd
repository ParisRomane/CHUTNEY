extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6
const AIR_FRICTION = 0.7
const FALLING_DISTANCE = 2
@export_group("Animation")
@export var my_anim_player : AnimationPlayer
@export_group("Camera")
@export var camera_controller : Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * 2
var cam_basis: Basis = transform.basis
var aerial_vel : Vector3
var last_grouned_alt : float

func _ready() -> void:
	var transition : AnimationNodeTransition = $AnimationTree.get_tree_root().get_node("Transition")
	# Enable the automatic transition between "jump" and "falling" animation when "jump" is finished
	transition.set_input_as_auto_advance(1, true)
	last_grouned_alt = global_position.y


func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directives : Dictionary = camera_controller.get_mov_directives({
		"left": Input.get_action_raw_strength("ui_left"),
		"right": Input.get_action_raw_strength("ui_right"),
		"up": Input.get_action_raw_strength("ui_up"),
		"down": Input.get_action_raw_strength("ui_down"),
		"jump": Input.get_action_raw_strength("ui_accept")
	})
	
	var direction : Vector3 = directives["direction"]
	if direction:
		look_at(global_position - direction, Vector3.UP)
	var current_rotation : Quaternion = transform.basis.get_rotation_quaternion()
	
	if not is_on_floor():
		# Add the gravity.
		velocity.y -= gravity * delta
		velocity.x = aerial_vel.x + direction.x
		velocity.z = aerial_vel.z + direction.z
		
		if global_position.y + FALLING_DISTANCE <= last_grouned_alt:
			$AnimationTree.set("parameters/Transition/transition_request", "falling")
		
	else:
		$AnimationTree.set("parameters/Transition/transition_request", "run")
		$AnimationTree.set("parameters/BlendSpace1D/blend_position", directives["blend_position"])
		var anim_vel : Vector3 = (current_rotation.normalized() * $AnimationTree.get_root_motion_position() / delta)
		velocity.x = anim_vel.x
		velocity.z = anim_vel.z
		
		aerial_vel = velocity * AIR_FRICTION
		last_grouned_alt = global_position.y
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimationTree.set("parameters/Transition/transition_request", "jump")
	
	

	move_and_slide()
