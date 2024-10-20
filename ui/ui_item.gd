extends HBoxContainer

var title : String
var desc : String

# Called when the node enters the scene tree for the first time.
func update() -> void:
	$VBoxContainer2/Label.text = title
