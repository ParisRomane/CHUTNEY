extends Node

var ovani : OvaniPlayer = null
var intro_music : PackedScene = preload("res://intro_music.tscn")
var intro_scene : PackedScene = preload("res://ui/intro.tscn")
var launch_btn : Button
var quit_btn : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ovani = intro_music.instantiate()
	launch_btn = $ButtonLaunch
	quit_btn = $ButtonQuitter
	
	self.get_parent().add_child.call_deferred(ovani)
	launch_btn.grab_focus()
	launch_btn.pressed.connect(self._button_start)
	quit_btn.pressed.connect(self._button_exit)
	
func _button_start() -> void :
	var intro : Node = intro_scene.instantiate()
	intro.ovani = self.ovani
	self.get_parent().add_child(intro)
	self.get_parent().remove_child(self)
	
func _button_exit() -> void :
	get_tree().quit(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass


func _on_button_credit_pressed() -> void:
	var credit : Node = load("res://ui/credit.tscn").instantiate()
	self.get_parent().add_child(credit)
	self.get_parent().remove_child(self)
