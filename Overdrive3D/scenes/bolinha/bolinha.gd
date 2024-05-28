extends RigidBody3D

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		set_linear_velocity(Vector3(0, 0, 0))
		set_angular_velocity(Vector3(0,0,0))
		set_position(Vector3(1.8, 1, 4))


func move_bolinha(player1, direcao):
	if player1:
		if direcao == "A":
			set_position(Vector3(position.x, 1, 4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_angular_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(-2, 3.5, -7))
		if direcao == "B":
			set_position(Vector3(position.x, 1, 4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(0, 3.5, -7))
		if direcao == "C":
			set_position(Vector3(position.x, 1, 4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(2, 3.5, -7))
	else:
		if direcao == "A":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(-2, 3.5, 7))
		if direcao == "B":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(0, 3.5, 7))
		if direcao == "C":
			set_position(Vector3(position.x, 1, -4))
			set_linear_velocity(Vector3(0, 0, 0))
			set_axis_velocity(Vector3(0,0,0))
			apply_central_impulse(Vector3(2, 3.5, 7))


