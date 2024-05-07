extends ShapeCast3D

@export var ball: RigidBody3D
@export var hit_cooldown: float = 1
@export var strength_multiplier: float = 1

var hit_countdown: float
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding() and hit_countdown <= 0:
		print("coliding")
		var normal = get_collision_normal(0)
		print(normal)
		ball.linear_velocity = Vector3(-ball.linear_velocity.x, -ball.linear_velocity.y, -ball.linear_velocity.z)
		hit_countdown = hit_cooldown
	else:
		hit_countdown -= delta
	pass
