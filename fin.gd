extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start('res://entities/character/fin.dtl')
	get_viewport().set_input_as_handled()

func _on_timeline_ended() -> void :
	$AnimationPlayer.play("new_animation")
