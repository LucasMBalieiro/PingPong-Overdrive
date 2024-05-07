extends Node3D

@export var player_speed: float = 1.54
@export var is_player_1: bool = true

var control_right: String
var control_left: String

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_player_1:
		control_right = "right-1"
		control_left = "left-1"
	else:
		control_right = "left-2"
		control_left = "right-2"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  Input.is_action_pressed(control_left):
		position.z -= player_speed * delta
	elif  Input.is_action_pressed(control_right):
		position.z += player_speed * delta
