extends Node3D

@export_category("Camera controller")

@export_group("Parameters")
@export var target : Marker3D
@export var is_active : bool = true

@export_group("Camera options")
@export var lerp_speed : float
@export var rot_speed : float
@export var max_zoom_dist : float = 10.0
@export var min_zoom_dist : float = 3.0
@export_range(0.1, 1.0) var zoom_speed : float = 1.0

var can_rotate : bool
var rot_performed : float
var sign : int
var cam_basis : Basis = Basis(transform.basis)

func _init() -> void:
	can_rotate = true
	rot_performed = 0.0
	rotation.y = 0.0

func _ready() -> void:
	
	if is_active:
		## TODO: Display a warning message in the editor if the target parent doesn't have a
		## "update_basis" method implemented.
		#cam_dir_changed.connect(target.get_parent_node_3d().update_basis)
		# Is important that the "connect" method is called here, after the initialisation of
		# the target node
		#_emit_camera_change()
		_camera_change()
		
		$Camera3D.current = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_active:
		global_position = global_position.lerp(target.global_position, lerp_speed)
		
		if Input.is_action_just_pressed("camera_left_rotation"):
			if can_rotate:
				sign = -1
				can_rotate = false
		
		elif Input.is_action_just_pressed("camera_right_rotation"):
			if can_rotate:
				sign = 1
				can_rotate = false
		
		if not can_rotate:
			camera_rotation(delta)

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("zoom_in"):
		_zoom(-1)
	
	if event.is_action_pressed("zoom_out"):
		_zoom(1)

## Get the rotation in radian that the camera must apply in the next frame. Sign MUST BE 1 or -1
func camera_rotation(delta: float) -> void:
	
	assert(sign == 1 or sign == -1, "Sign must be 1 or -1")
	
	var rot_added: float = deg_to_rad(90.0*(delta/rot_speed))
	
	if rad_to_deg(rot_performed + rot_added) < 90.0:
		rotation.y += sign * rot_added
		rot_performed += rot_added
	
	else:
		rotation.y += sign * (deg_to_rad(90.0) - rot_performed)
		rot_performed = 0.0
		can_rotate = true
		# Inform the character script that the movement basis has changed.
		# We send a basis rotated from 45 degrees to the Y axis (Vector3i.UP) for compensate the
		# camera angle offset.
		_camera_change()

## TODO: The zoom handling must be changed, the movement of the camera has to be smoother.
func _zoom(sign: int) -> void:
	
	assert(sign == 1 or sign == -1, "Sign must be 1 or -1")
	
	var next_cam_pos: Vector3 = $Camera3D.position + (sign * Vector3(zoom_speed, zoom_speed, zoom_speed))
	var offset: float = target.position.distance_to(next_cam_pos)
	
	if offset < max_zoom_dist and offset > min_zoom_dist:
		$Camera3D.position = next_cam_pos

## Return a dictionary with the variables to give for player's displacement and animation.
## Param inputs : a dictionary containing the character's controller intputs.
func get_mov_directives(inputs: Dictionary) -> Dictionary:
	
	var input_dir := Vector2(inputs["right"] - inputs["left"], inputs["down"] - inputs["up"])
	var direction : Vector3 = (self.cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	return {"direction": direction, "blend_position": Vector3(0, int(direction != Vector3.ZERO), 0)}

func _camera_change() -> void:
	cam_basis = Basis(transform.basis).rotated(Vector3i.UP, deg_to_rad(45))
