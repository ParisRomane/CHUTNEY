extends CharacterBody2D

var mouse_pos := Vector2()
var vel := Vector2()

#Key var
var right : bool
var left : bool
var up : bool
var down : bool

@export var max_speed = 300

var ACC = 50

func _ready():
	pass

func _physics_process(delta):	# 60 FPS
	action_loop()
	set_velocity(vel)
	move_and_slide()
	vel = velocity
	camera_management(delta)

func action_loop():
	
	right = Input.is_action_pressed("ui_right")
	left = Input.is_action_pressed("ui_left")
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	move = right or left or up or down
	shoot = Input.is_action_just_pressed("shoot")
	
	sound_management()
	movement_loop()
	animation_loop()
	shooting()

func movement_loop():
	
	if !is_dead:
		if right:
			vel.x = min(vel.x + ACC, max_speed)
		if left:
			vel.x = max(vel.x - ACC, -max_speed)
		if up:
			vel.y = max(vel.y - ACC, -max_speed)
		if down:
			vel.y = min(vel.y + ACC, max_speed)
	
	#Inertia management
	if !move or is_dead:
		vel.x = lerpf(vel.x, 0, 0.15)
		vel.y = lerpf(vel.y, 0, 0.15)
	
	#Rotation management
	if !is_dead:
		mouse_pos = get_global_mouse_position()
		shoot_line = mouse_pos - global_position
		look_at(mouse_pos)
		look_at(mouse_pos)

func shooting():
	var dispersion = 0.0
	
	if shoot and can_shoot and !is_dead:
		can_shoot = false
		var b : Bullet = bullet.instantiate()
		var rotation = shoot_line.angle()
		
		#Bullet spawn
		self.add_collision_exception_with(b)
		b.start($Muzzle.global_position, rotation - dispersion, 10)
		get_parent().add_child(b)
		
		var frequence = 8.
		$Reload.wait_time = 1/frequence
		
		#Timer start
		if $Reload.is_stopped():
			$Reload.start()

func animation_loop():
	pass
	
func camera_management(delta):
	get_parent().get_node("Cameraman").move_and_collide(vel*delta)

func sound_management():
	pass

func die():
	if !is_dead:
		is_dead = true
		dying = true
		$".".set_z_index($".".get_z_index()-2)
		$CollisionShape2D.set_disabled(true)

func _on_reload_timeout():
	can_shoot = true
