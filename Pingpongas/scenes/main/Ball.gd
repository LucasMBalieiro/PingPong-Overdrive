extends RigidBody3D

@export var table_x_start: float
@export var table_x_end: float
@export var table_y_height: float
@export var table_z_start: float
@export var table_z_end: float

var impulse_applied: bool
var starting_pos: Vector3
var starting_velocity: Vector3
# Called when the node enters the scene tree for the first time.
func _ready():
	starting_pos = global_position
	starting_velocity = linear_velocity
	impulse_applied = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.y < 0:
		reset()
		return
	var inside_x: bool = global_position.x > table_x_start and global_position.x < table_x_end
	var inside_z: bool = global_position.z > table_z_start and global_position.z < table_z_end
	var below_y: bool = global_position.y < table_y_height
	if inside_x and inside_z and below_y and not impulse_applied:
		print("Aplicando impulso")
		linear_velocity = Vector3(linear_velocity.x, -linear_velocity.y, linear_velocity.z)
		global_position = Vector3(global_position.x, table_y_height, global_position.z)
		impulse_applied = true
	else:
		impulse_applied = false
	pass
	
func reset():
	global_position = starting_pos
	linear_velocity = starting_velocity
