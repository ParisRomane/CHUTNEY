extends Node2D

var ovani : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("shake")
		

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name :
		"shake" : 
			$AnimationPlayer.play("shake_end")
		"shake_end" :
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.start('res://entities/character/debut_jeu.dtl')
			get_viewport().set_input_as_handled()

func _on_timeline_ended() -> void :
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	var test_scene : Node = load("res://levels/level_1.tscn").instantiate()
	self.get_parent().add_child(test_scene)
	print(ovani)
	if ovani != null :
		self.get_parent().remove_child(ovani)
	var music : Node = load("res://ambiance_music_loop.tscn").instantiate()
	self.get_parent().add_child.call_deferred(music)
	self.get_parent().remove_child(self)
