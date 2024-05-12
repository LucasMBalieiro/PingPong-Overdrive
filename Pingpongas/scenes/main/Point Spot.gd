extends MeshInstance3D

var was_moved: bool
var original_pos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	original_pos = global_position
	was_moved = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move(new_pos: Vector3):
	if not was_moved:
		global_position = new_pos
		was_moved = true
	

func reset():
	was_moved = false
	global_position = original_pos
