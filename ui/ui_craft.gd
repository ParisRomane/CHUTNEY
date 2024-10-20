extends Control

@export var ship : Ship
var item : Resource = preload("res://ui/ui_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key : String in ship._crafts:
		if key != "cc_set_craft_multiplier":
			var craft : Craft = ship._crafts[key][ship._craft_tier[key]]
			$VBoxContainer.add_child(craft_to_item(craft))

func craft_to_item(craft : Craft) -> Node:
	var i : Control = item.instantiate()
	return Node.new()
