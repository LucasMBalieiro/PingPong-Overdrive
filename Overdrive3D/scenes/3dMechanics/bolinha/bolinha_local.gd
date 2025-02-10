extends RigidBody3D
var speed = 1.3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var player1_previous_hit: bool = true
var bounce_count: int = 0
var has_started: bool = false
@onready var hitsound = $hitsound

func _ready():
	contact_monitor = true
	set_max_contacts_reported(1)
	Engine.set_physics_ticks_per_second(128)
	GameManager.register_to_receive_score(smart_reset)

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		SendHasReset()
	if position.y < -5:
		SendHasReset()
	

#TODO: eu nao tenho a MINIMA ideia de como funciona o placar, taquei o fds e to resetando a bolinha só pela posiçao qnd cai
#RELAXA, EU CUIDO DISSO, FIZ UM ESPAGUETE COM ESSE PLACAR
#@rpc("any_peer", "call_local")
func reset_bolinha(player1 = null, player2 = null):
	# Players são os dicionarios de GameManager
	
	has_started = false
	bounce_count = 0
	speed = 1.3
	if player1 == null or player2 == null:
		set_position(Vector3(1.8, 1, 4))
	elif player2.player_assigned_number == 1 and player2.is_scoring:
		set_position(Vector3(-1.8, 1, -4))
	elif player1.player_assigned_number == 1 and player1.is_scoring:
		set_position(Vector3(-1.8, 1, -4))
	else:
		set_position(Vector3(1.8, 1, 4))
	set_linear_velocity(Vector3(0, 0, 0))
	set_angular_velocity(Vector3(0,0,0))
	set_rotation(Vector3(0,0,0))
	gravity_scale = 0
	GameManager.reset_bolinha()
	
func smart_reset(player1: Dictionary, player2: Dictionary):
	reset_bolinha(player1, player2)

func move_bolinha(player1, direcao):
	
	if speed <= 2.5:
		speed += 0.1
	gravity_scale = speed * speed
	if player1:
		set_last_player_hit(true)
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
			apply_central_impulse(Vector3(2, 3.5, 7) * speed)
		if direcao == "B":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(0, 3.5, 7) * speed)
		if direcao == "C":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(-2, 3.5, 7) * speed)

func set_last_player_hit(player1: bool):
	has_started = true
	player1_previous_hit = player1

func _on_body_entered(body):
	hitsound.play() #TODO: fazer essa desgraça ficar constante, pq que do nada o audio para??? 
	if not has_started:
		return
	SendBallInformation(player1_previous_hit, position)

func SendBallInformation(player1, ball_position):
	GameManager.set_bolinha_info(player1, ball_position)

func SendHasStarted():
	GameManager.mark_as_started()

func SendHasReset():
	GameManager.mark_as_reset()
