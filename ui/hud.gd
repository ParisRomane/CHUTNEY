class_name HUD
extends Control

@export var player : Player 
@export var ship : Ship 
var vide : ColorRect
var plein : ColorRect
var nom_craft: Label
var desc_craft: Label
var short_craft: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vide = $RessourcesPlacement/Fuel/Vide
	plein = $RessourcesPlacement/Fuel/Plein
	nom_craft = $Craft/Nom
	desc_craft = $Craft/LongDesc
	short_craft = $Craft/Shortdesc
	ship._craft.call_deferred(nom_craft, desc_craft, short_craft, $Craft/ButtonCraft, $Craft)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	plein.size.y = player.current_fuel * .5
	vide.size.y = player.max_fuel * .5
	if Input.is_action_just_pressed('ui_cancel'):
		var fin : Node = load("res://fin.tscn").instantiate()
		self.get_parent().add_child(fin)
		self.get_parent().remove_child(self)


func _on_area_2d_body_entered(area: Node) -> void:
	if (area.has_method("collect")):
		var fin : Node = load("res://fin.tscn").instantiate()
		self.get_parent().add_child(fin)
		self.get_parent().remove_child(self)
	
