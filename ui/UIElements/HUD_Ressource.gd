extends Control

@export var hud: HUD
var player: Player
var ship : Ship
@export_enum("organic", "scrap", "electronic") var type: String
var nb_res: int
var nb_inv: int
var nb_transfer: int = 0
var transfer_rate: int = 1
var last_change: float
var transfering: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nb_res = 0
	nb_inv = 0
	transfering = false
	ship = hud.ship
	player = hud.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	last_change -= delta
	if not transfering and last_change <= 0.:
		last_change = 0.
		if nb_inv > 0 and player.inventory.get(type) == 0:
			_launch_transfer()
		elif nb_inv < player.inventory.get(type) :
			_increase_player_res()
		elif nb_inv > player.inventory.get(type) :
			_decrease_player_res()
		elif nb_res < ship.inventory.get(type) :
			_increase_ship_res()
		elif nb_res > ship.inventory.get(type) :
			_decrease_ship_res()
			
	
func _get_str_res(res:int) -> String:
	return "0" + str(res) if res < 10 else str(res)

func _get_player_text(res:int) -> String:
	return "(+" + _get_str_res(res) + ")"
	

func _launch_transfer() -> void:
	if not transfering:
		transfering = true
		transfer_rate = 1
		_transfer_to_ship()
		
	
func _transfer_to_ship() -> void:
	nb_transfer += 1
	if nb_inv <= 0:
		transfering = false
		nb_transfer = 0
		$Stock_player.hide()
		return
	if nb_transfer > 2 and nb_inv % (2* transfer_rate) == 0:
		transfer_rate *= 2
		
	nb_inv -= transfer_rate
	nb_res += transfer_rate
	$Stock_player.text = _get_player_text(nb_inv)
	$Stock_ship.text = _get_str_res(nb_res)
	$Anim_Stock_ship.play("Transfer_to_ship")
	
func _increase_player_res() -> void:
	$Stock_player.show()
	nb_inv = player.inventory[type]
	$Stock_player.text = _get_player_text(nb_inv)
	last_change = .4
	$Anim_Stock_ship.play("Increase_player")
	
	
func _decrease_player_res() -> void:
	nb_inv -= 1
	$Stock_player.text = _get_player_text(nb_inv)
	if nb_inv <= 0:
		$Stock_player.hide()
	else:
		pass
		#todo anim
	
func _increase_ship_res() -> void:
	nb_res += 1
	$Stock_ship.text = _get_str_res(nb_res)
	#todo anim
	
func _decrease_ship_res() -> void:
	var nb_diff : int = nb_res - ship.inventory[type]
	$Stock_ship_craft.text = _get_str_res(nb_diff)
	nb_res = ship.inventory[type]
	$Stock_ship.text = _get_str_res(nb_res)
	last_change = .8
	$Anim_Stock_ship.play("Decrease_ship")
