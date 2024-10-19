class_name Ship
extends CharacterBody2D

var inventory : Ressource
var _multiplier : int = 0

func _ready() -> void:
	inventory = Ressource.new(0,0,0)

func _on_collect_area_body_entered(body: Node2D) -> void:
	
	if body.has_method("collect"):
		inventory.add_with_multiplier(body.inventory, _multiplier)
		body.inventory.reset()
