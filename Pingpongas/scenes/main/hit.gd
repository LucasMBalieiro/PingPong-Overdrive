extends ShapeCast3D

@export var clamp_z: float = 90
@export var hit_cooldown: float = 1
@export var is_player_1: bool = true
@export var ball: RigidBody3D
@export var strength_multiplier: float = 3
@export var upward_strength: float = 0.8

var control_hit: String
var hit_countdown: float
var ball_script: Script

# Called when the node enters the scene tree for the first time.
func _ready():
	hit_countdown = 0
	if is_player_1:
		control_hit = "hit-1"
	else:
		control_hit = "hit-2"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed(control_hit) and hit_countdown <= 0:
		hit_countdown = hit_cooldown
		print("Pressed!")
		if is_colliding():
			var player: int = 1 if is_player_1 else 2
			ball.hit(global_position, strength_multiplier, player)
		
	else:
		hit_countdown -= delta
	pass
