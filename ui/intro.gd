extends Node2D

var ovani : Node
var anim_player : AnimationPlayer
var HUD_scene : PackedScene = preload("res://ui/HUD.tscn")
var music_scene : PackedScene = preload("res://ambiance_music_loop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player = $AnimationPlayer
	anim_player.play("shake")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name :
		"shake" : 
			anim_player.play("shake_end")
		"shake_end" :
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.start('res://entities/character/debut_jeu.dtl')
			get_viewport().set_input_as_handled()

func _on_timeline_ended() -> void :
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	self.get_parent().add_child(HUD_scene.instantiate())
	
	if ovani != null :
		self.get_parent().remove_child(ovani)
	var music : Node = music_scene.instantiate()
	self.get_parent().add_child.call_deferred(music)
	self.get_parent().remove_child(self)
