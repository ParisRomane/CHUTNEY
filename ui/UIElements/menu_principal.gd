extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ButtonLaunch.grab_focus()
	$ButtonLaunch.pressed.connect(self._button_start)
	
	$ButtonQuitter.pressed.connect(self._button_exit)
	
func _button_start() -> void :
	get_tree().change_scene_to_file("res://levels/test_scene.tscn")
	
func _button_exit() -> void :
	get_tree().quit(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass


func _on_button_credit_pressed() -> void:
	var credit : Node = load("res://ui/credit.tscn").instantiate()
	self.get_parent().add_child(credit)
	self.get_parent().remove_child(self)
