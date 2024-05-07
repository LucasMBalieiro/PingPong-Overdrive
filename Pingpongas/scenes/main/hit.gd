extends ShapeCast3D

@export var clamp_z: float = 90
@export var hit_cooldown: float = 1
@export var is_player_1: bool = true
@export var ball: RigidBody3D
@export var strength_multiplier: float = 0.1
@export var upward_strength: float = 0.8

var control_hit: String
var hit_countdown: float


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
			var normal = get_collision_normal(0)
			var upward_velocity = 0
			if ball.linear_velocity.y < 0:
				upward_velocity = -ball.linear_velocity.y
			elif ball.linear_velocity.y < upward_strength:
				upward_velocity += upward_strength
			
			print(normal)
			print(Vector3(
				-ball.linear_velocity.x,
				upward_velocity,
				-normal.z).normalized() * strength_multiplier, global_position)
			ball.apply_impulse(Vector3(
				-ball.linear_velocity.x,
				upward_velocity,
				-normal.z).normalized() * strength_multiplier, global_position)
		
	else:
		hit_countdown -= delta
	pass
