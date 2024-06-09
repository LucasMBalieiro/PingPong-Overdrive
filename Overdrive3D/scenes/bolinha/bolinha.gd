extends RigidBody3D
var speed = 1.3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Engine.set_physics_ticks_per_second(128)

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		set_linear_velocity(Vector3(0, 0, 0))
		set_angular_velocity(Vector3(0,0,0))
		set_position(Vector3(1.8, 1, 4))
		set_rotation(Vector3(0,0,0))
		
	if Input.is_action_just_pressed("gravity"):
		speed = 1.3


func move_bolinha(player1, direcao):
	
	if speed <= 2.5:
		speed *= 1.05

	if player1:
		gravity_scale = speed * speed
		if direcao == "A":
			set_position(Vector3(position.x, 1, 4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_angular_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(-2, 3.5, -7) * speed)
		if direcao == "B":
			set_position(Vector3(position.x, 1, 4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(0, 3.5, -7) * speed)
		if direcao == "C":
			set_position(Vector3(position.x, 1, 4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(2, 3.5, -7) * speed)
	else:
		if direcao == "A":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(-2, 3.5, 7) * speed)
		if direcao == "B":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(0, 3.5, 7) * speed)
		if direcao == "C":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(2, 3.5, 7) * speed)

