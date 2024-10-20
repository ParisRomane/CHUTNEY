extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("shake")
		

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name :
		"shake" : 
			$AnimationPlayer.play("shake_end")
		"shake_end" :
			var test_scene : Node = load("res://levels/test_scene.tscn").instantiate()
			self.get_parent().add_child(test_scene)
			self.get_parent().remove_child(self)
