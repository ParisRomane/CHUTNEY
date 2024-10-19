extends StaticBody2D

@export var texture : Texture2D
@export var type : int = 0
@export var is_hazardous : bool = false

var _multiplier : int = 1

func _ready() -> void:
	Sprite2D.texture = texture
	
	if is_hazardous:
		_multiplier = 2
	
func get_resources() -> Ressource:
	var rsc : Array = [
			Ressource.new(1*_multiplier,0,0), 
			Ressource.new(0,1*_multiplier,0), 
			Ressource.new(0,0,1*_multiplier),
			]
	return rsc[type]


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("collect"):
		body.collect(get_resources())
