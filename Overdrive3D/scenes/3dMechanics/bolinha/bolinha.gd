extends RigidBody3D
var speed = 1.3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var player1_previous_hit: bool = true
var bounce_count: int = 0
var has_started: bool = false

func _ready():
	contact_monitor = true
	set_max_contacts_reported(1)
	Engine.set_physics_ticks_per_second(128)

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		reset_bolinha.rpc()		
		
	if Input.is_action_just_pressed("gravity"):
		speed = 1.3
		
@rpc("any_peer", "call_local")
func reset_bolinha():
	has_started = false
	bounce_count = 0
	set_linear_velocity(Vector3(0, 0, 0))
	set_angular_velocity(Vector3(0,0,0))
	set_position(Vector3(1.8, 1, 4))
	SendHasReset.rpc()

@rpc("any_peer", "call_local")
func move_bolinha(player1, direcao):
	
	if speed <= 2.5:
		speed += 0.1
	
	if player1:
		set_last_player_hit(true)
		gravity_scale = speed * speed
		if direcao == "A":
			set_position(Vector3(position.x, 1, 4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_angular_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(-2, 3.5, -7) * speed)
		if direcao == "B":
			set_position(Vector3(position.x, 1, 4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(0, 3.5, -7) * speed)
		if direcao == "C":
			set_position(Vector3(position.x, 1, 4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(2, 3.5, -7) * speed)
	else:
		set_last_player_hit(false)
		if direcao == "A":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(-2, 3.5, 7) * speed)
		if direcao == "B":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(0, 3.5, 7) * speed)
		if direcao == "C":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(2, 3.5, 7) * speed)
			
func set_last_player_hit(player1: bool):
	has_started = true
	player1_previous_hit = player1

func _on_body_entered(body):
	if not has_started:
		return
	if multiplayer.is_server():
		SendBallInformation(player1_previous_hit, position)
	
@rpc()
func SendBallInformation(player1, ball_position):
	GameManager.set_bolinha_info(player1, ball_position)
	if multiplayer.is_server():
		ReceiveBallInformation.rpc(player1, ball_position)
	
@rpc("any_peer")
func ReceiveBallInformation(player1, ball_position):
	GameManager.set_bolinha_info(player1, ball_position)

@rpc("any_peer")
func SendHasStarted():
	GameManager.mark_as_started()

@rpc("any_peer")
func SendHasReset():
	GameManager.mark_as_reset()
