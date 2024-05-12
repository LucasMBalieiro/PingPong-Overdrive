extends Node

@export var score_board: RichTextLabel
@export var timer_time: float = 5
@export var point_spot: MeshInstance3D

var score_player_1: int
var score_player_2: int

var timer_started: bool
var timer: float

var timer_callback: Callable
var timer_increment: int

var last_bounce_player: int
var bounce_own_field: int
var bounce_oponent_field: int

# Called when the node enters the scene tree for the first time.
func _ready():
	score_player_1 = 0
	score_player_2 = 0
	reset_bounce()
	update_score()
	timer = 0
	point_spot.reset()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_started:
		if timer < 0:
			timer_started = false
			timer_callback.call()
			increment(timer_increment)
			reset_bounce()
			point_spot.reset()
		else:
			timer -= delta
	pass

func update_score():
	score_board.text = "{player_1}-{player_2}".format({"player_1": score_player_1,
	"player_2": score_player_2})
	
func increment(player: int):
	if player == 1:
		score_player_1 += 1
	elif player == 2:
		score_player_2 += 1
	update_score()
	
func floor_rule(last_player: int, callback: Callable):
	var player_to_inc: int
	if last_player != last_bounce_player:
		player_to_inc = get_oponent(last_player)
	else:
		if bounce_oponent_field != 1:
			player_to_inc = get_oponent(last_player)
		else:
			player_to_inc = last_player
	start_timer(player_to_inc, callback)
		
func bounce_rule(ball_pos: Vector3, player: int, player_is_neg: bool, callback: Callable):
	if player != last_bounce_player:
		last_bounce_player = player
		bounce_own_field = 0
		bounce_oponent_field = 0
		
	if (ball_pos.x < 0 and player_is_neg) or (ball_pos.x > 0 and not player_is_neg):
		bounce_own_field += 1
	else:
		bounce_oponent_field += 1
	
	if bounce_own_field == 2:
		var inc_player: int = get_oponent(player)
		start_timer(inc_player, callback)
		point_spot.move(ball_pos)
		return
	if bounce_oponent_field == 2:
		start_timer(player, callback)
		point_spot.move(ball_pos)
		return
	
func start_timer(player: int, callback: Callable):
	if not timer_started:
		timer_increment = player
		timer_callback = callback
		timer = timer_time
		timer_started = true

func reset_bounce():
	last_bounce_player = 0
	bounce_own_field = 0
	bounce_oponent_field = 0
	
func get_oponent(player: int):
	if player == 1:
		return 2
	return 1
