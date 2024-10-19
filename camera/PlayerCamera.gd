extends CharacterBody2D

@export_category("Camera controller")

@export_group("Parameters")
@export var target : Node

@export_group("Camera options")
@export var max_zoom_dist : float = 1
@export var min_zoom_dist : float = 0.2
@export var zoom_step : float = 0.05
@export var MAX_DIST := 2000
@export var CAMERA_SPEED := 5000


func _process(delta: float) -> void:	# /!\ WORKAROUND /!\
	
	var player_pos : Vector2 = target.position
	
	if Input.is_action_pressed("aim") :
		var vel : Vector2 = Vector2(CAMERA_SPEED, 0).rotated((get_global_mouse_position() - position).angle())
		var next_pos : Vector2 = position + vel*delta
		var delta_dist : float = 2.*(MAX_DIST - player_pos.distance_to(next_pos))/MAX_DIST
		
		if player_pos.distance_to(next_pos) <= MAX_DIST:
			move_and_collide(vel*delta*delta_dist)
		
	else:
		position = player_pos

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("zoom_in"):
		_zoom(1)
	
	if event.is_action_pressed("zoom_out"):
		_zoom(-1)

## TODO: The zoom handling must be changed, the movement of the camera has to be smoother.
func _zoom(sign: int) -> void:
	
	assert(sign == 1 or sign == -1, "Sign must be 1 or -1")
	var zoom : Vector2 = $Camera2D.get_zoom()
	
	var ammount_to_add: Vector2 = zoom + Vector2(sign * zoom_step, sign * zoom_step)
	if ammount_to_add.x < max_zoom_dist and ammount_to_add.x > min_zoom_dist:
		$Camera2D.set_zoom(ammount_to_add)
