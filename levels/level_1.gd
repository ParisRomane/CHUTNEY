extends Node2D


var perso_offset : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	perso_offset = $Path2D/Player.position - $Sprite2D.position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.position = $Path2D/Player.position - self.perso_offset
