extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("interact"):
		speak()

func speak() -> void:
	$AnimationTree.set("parameters/Mouth/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	$AudioStreamPlayer3D.play()
