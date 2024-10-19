extends Control


func _on_retour_pressed() -> void:
	var menu : Node = load("res://ui/MenuPrincipal.tscn").instantiate()
	self.get_parent().add_child(menu)
	self.get_parent().remove_child(self)
