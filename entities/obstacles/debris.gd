extends StaticBody2D

@export var texture : Texture2D
@export var type : enums.dbr_type
@export var hazard_type : enums.hazard

var _multiplier : int = 1

func _ready() -> void:
	$Sprite2D.texture = texture
	
	if !hazard_type == enums.hazard.NONE :
		_multiplier = 2
	
func get_resources() -> Ressource:
	var rsc : Array = [
			Ressource.new(1*_multiplier,0,0), 
			Ressource.new(0,1*_multiplier,0), 
			Ressource.new(0,0,1*_multiplier),
			]
	return rsc[type]


func _on_dmg_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(true)
		hazard_behaviour(body)
		
func _on_dmg_area_body_exited(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(false)


func _on_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("collect"):
		body.collect(get_resources())
		self.queue_free()

func hazard_behaviour(body: Node2D) -> void:
	pass
