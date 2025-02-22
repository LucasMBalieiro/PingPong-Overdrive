extends Node

var Players = {}
var Bolinha = {}
var number_to_id = {}

var bounce_timeout:float = 10
var set_points = 11

var game_started: bool = false

var score_update_callback: Array[Callable] = []
var game_win_update_callback: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_bolinha()
	game_started = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("close"):
		get_tree().quit()

func reset_bolinha():
	Bolinha = {
		"player1_last_hit": false,
		"bounce_count": 0,
		"position": Vector3(0,0,0),
		"one_bounce_in_own_field": false
	}

func build_player_number_to_id_rel():
	for id in Players:
		var number = Players[id].player_assigned_number
		number_to_id[number] = id

func register_to_receive_score(callback):
	score_update_callback.append(callback)

func update_score():
	check_game_sets()
	for callback_func in score_update_callback:
		callback_func.call(Players[number_to_id[0]], Players[number_to_id[1]])

func register_to_receive_win(callback, player_number):
	game_win_update_callback[player_number] = callback

func send_game_win(player_number):
	if game_win_update_callback.has(player_number):
		game_win_update_callback[player_number].call(Players[number_to_id[player_number]].name)
	get_tree().paused = true

func check_game_sets():
	if Players[number_to_id[0]].score >= (set_points - 1) and Players[number_to_id[1]].score >= (set_points - 1):
		if Players[number_to_id[0]].score >= (Players[number_to_id[1]].score + 2):
			Players[number_to_id[0]].set_points += 1
			Players[number_to_id[0]].score = 0
			Players[number_to_id[1]].score = 0
		if Players[number_to_id[1]].score >= (Players[number_to_id[0]].score + 2):
			Players[number_to_id[1]].set_points += 1
			Players[number_to_id[1]].score = 0
			Players[number_to_id[0]].score = 0
	else:
		if Players[number_to_id[0]].score >= set_points:
			Players[number_to_id[0]].set_points += 1
			Players[number_to_id[0]].score = 0
			Players[number_to_id[1]].score = 0
		
		if Players[number_to_id[1]].score >= set_points:
			Players[number_to_id[1]].set_points += 1
			Players[number_to_id[1]].score = 0
			Players[number_to_id[0]].score = 0

	if Players[number_to_id[0]].set_points == 3:
		send_game_win(0)
	if Players[number_to_id[1]].set_points == 3:
		send_game_win(1)

func add_point(player: int):
	var player_id = number_to_id[player]
	var oponent_id = number_to_id[int(not bool(player))]
	Players[player_id].score += 1
	Players[player_id].is_scoring = true
	Players[oponent_id].is_scoring = false
	update_score()
	Players[player_id].is_scoring = false
	Players[oponent_id].is_scoring = false
	pass
	
func check_bounce_in_own_field(player1: bool):
	var oponent: int = 1 if player1 else 0
	if Bolinha.one_bounce_in_own_field:
		add_point(oponent)
	else:
		Bolinha.one_bounce_in_own_field = true
		
func check_bounce_in_oponent_field(player1: bool, reset: bool):
	var player: int = 0 if player1 else 1
	var oponent_field_bounce = Bolinha.bounce_count
	if Bolinha.one_bounce_in_own_field:
		oponent_field_bounce -= 1
	if oponent_field_bounce > 1:
		add_point(player)
	elif reset:
		add_point(player)

func validate_score(reset: bool):
	if Bolinha.player1_last_hit:
		if Bolinha.position.z > 0:
			check_bounce_in_own_field(Bolinha.player1_last_hit)
		else:
			check_bounce_in_oponent_field(Bolinha.player1_last_hit, reset)
	else:
		if Bolinha.position.z < 0:
			check_bounce_in_own_field(Bolinha.player1_last_hit)
		else:
			check_bounce_in_oponent_field(Bolinha.player1_last_hit, reset)

func set_bolinha_info(player1: bool, ball_position: Vector3):
	if player1 != Bolinha.player1_last_hit:
		reset_bolinha()
	Bolinha.player1_last_hit = player1
	Bolinha.bounce_count += 1
	Bolinha.position = ball_position
	validate_score(false)
	
func mark_as_started():
	game_started = true
	
func mark_as_reset():
	validate_score(true)
	
	
