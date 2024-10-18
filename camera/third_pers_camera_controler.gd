extends Node3D

@export_category("Camera controller")

@export_group("Parameters")
@export var target : Marker3D
@export var is_active : bool = true

@export_group("Camera options")
@export var lerp_speed : float

var _y_rotation: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_active:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$Mount/SpringArm3D/Camera3D.current = true

func _input(event: InputEvent) -> void:
	if is_active:
		if event is InputEventMouseMotion:
			_y_rotation = deg_to_rad(-event.relative.x)
			rotate_y(deg_to_rad(-event.relative.x))
			$Mount.rotate_z(deg_to_rad(event.relative.y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		global_position = global_position.lerp(target.global_position, lerp_speed)

## Return a dictionary with the variables to give for player's displacement and animation.
## Param inputs : a dictionary containing the character's controller intputs.
func get_mov_directives(inputs: Dictionary) -> Dictionary:
	
	var input_dir := Vector2(inputs["right"] - inputs["left"], inputs["down"] - inputs["up"]).rotated(_y_rotation)
	var direction := (transform.basis * Vector3(input_dir.y, 0, -input_dir.x)).normalized()
	
	return {"direction": direction, "blend_position": int(direction != Vector3.ZERO)}
