extends Path2D

@export var player : Player
@export var max_rope_len : float = 3000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()

func _process(delta: float) -> void:
	max_rope_len = player.longueur_corde
	if player.can_move:
		$Line2D.set_point_position(get_size()-1, player.global_position)
		curve.set_point_position(get_size()-1, player.global_position)
		
		var rope_len : float = curve.get_baked_length()
		if rope_len > max_rope_len:
			player.rope_end()
	else:
		if get_size() >= 1 :
			$Line2D.set_point_position(get_size()-1, player.global_position)

func _input(event: InputEvent) -> void :
	if Input.is_action_pressed("shoot") and player.can_move:
		update()

func update() -> void:
	curve.add_point(player.global_position)
	$Line2D.add_point(player.global_position)

func get_size() -> int:
	return $Line2D.points.size()
