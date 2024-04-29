extends StaticBody2D
@export var jogador1: bool
var velo_player: int = 300
var hit_cooldown: float = 1.0  # Cooldown time in seconds
var last_hit_time: float = 0.0  # Time when the last hit occurred

var collision_shape: CollisionShape2D

func _ready():
	collision_shape = $CollisionShape2D
	collision_shape.disabled = true 


func _process(delta):
	move_jogador(delta)
	limit_position()


func move_jogador(delta):
	if jogador1:
		if  Input.is_action_pressed("left-1"):
			position.x -= velo_player * delta
		elif  Input.is_action_pressed("right-1"):
			position.x += velo_player * delta
		elif  Input.is_action_pressed("hit-1") and can_hit():
			collision_shape.disabled = false
			last_hit_time = Time.get_ticks_msec() / 1000.0 
		elif not Input.is_action_pressed("hit-1"):
			collision_shape.disabled = true
	else:
		if  Input.is_action_pressed("left-2"):
			position.x -= velo_player * delta
		elif  Input.is_action_pressed("right-2"):
			position.x += velo_player * delta
		elif  Input.is_action_pressed("hit-2") and can_hit():
			collision_shape.disabled = false
			last_hit_time = Time.get_ticks_msec() / 1000.0  # Record the time of the hit
		elif not Input.is_action_pressed("hit-2"):
			collision_shape.disabled = true


func limit_position():
	position.x = clamp(position.x,400,880)

func can_hit():
	return Time.get_ticks_msec() / 1000.0 - last_hit_time >= hit_cooldown
