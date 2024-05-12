extends RigidBody3D

@export var table_x_start: float
@export var table_x_end: float
@export var table_y_height: float
@export var table_z_start: float
@export var table_z_end: float
@export var game_manager: Node

var impulse_applied: bool
var starting_pos: Vector3
var starting_velocity: Vector3

var last_hit_player: int
var last_hit_player_is_neg: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	starting_pos = global_position
	starting_velocity = linear_velocity
	impulse_applied = false
	last_hit_player = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.y < 0:
		game_manager.floor_rule(last_hit_player, reset)
		bounce_floor()
		return
	bounce_table()
	pass
	
func bounce_table():
	var inside_x: bool = global_position.x > table_x_start and global_position.x < table_x_end
	var inside_z: bool = global_position.z > table_z_start and global_position.z < table_z_end
	var below_y: bool = global_position.y < table_y_height
	if inside_x and inside_z and below_y and not impulse_applied:
		linear_velocity = Vector3(linear_velocity.x, -linear_velocity.y, linear_velocity.z)
		global_position = Vector3(global_position.x, table_y_height, global_position.z)
		impulse_applied = true
		game_manager.bounce_rule(global_position, last_hit_player, last_hit_player_is_neg, reset)
	else:
		impulse_applied = false
		
func bounce_floor():
	var below_ground: bool = global_position.y < 0
	if below_ground and not impulse_applied:
		linear_velocity = Vector3(linear_velocity.x, -linear_velocity.y, linear_velocity.z)
		global_position = Vector3(global_position.x, 0, global_position.z)
		impulse_applied = true
	else:
		impulse_applied = false
	
func reset():
	global_position = starting_pos
	linear_velocity = starting_velocity
	last_hit_player = 0
	
func hit(paddle_pos: Vector3, strength: float, player: int):
	print("PADDLE: ", paddle_pos)
	last_hit_player = player
	last_hit_player_is_neg = paddle_pos.x < 0
	
	var ball_pos = global_position
	var ball_velocity = linear_velocity
	var hit_vector = (ball_pos - paddle_pos).normalized()
	var hit_distance = ball_pos.distance_to(paddle_pos)
	var hit_strenght = clamp(1 / abs(hit_distance), 1, strength)
	print("HIT: ", hit_vector)
	print("DISTANCE: ", hit_distance)
	print("Strenght: ", hit_strenght)
	var new_x = -ball_velocity.x + (hit_vector.x * hit_strenght)
	var new_z = ball_velocity.z + (hit_vector.z * hit_strenght)
	var new_y = 0
	if ball_velocity.y < 0:
		new_y = -ball_velocity.y
	elif ball_velocity.y < hit_strenght:
		new_y += hit_strenght
	linear_velocity = Vector3(
		new_x,
		new_y,
		new_z
	)
	print("NEW VEL: ", linear_velocity)
	
	
