extends StaticBody2D

@export var jogador1: bool
var velocidade: int = 300 

func _ready():
	pass 


func _process(delta):
	move_jogador(delta)
	limit_position()


func move_jogador(delta):
	if jogador1:
		if  Input.is_action_pressed("left-1"):
			position.x -= velocidade * delta
		elif  Input.is_action_pressed("right-1"):
			position.x += velocidade * delta
		elif  Input.is_action_pressed("hit-1"):
			pass
	else:
		if  Input.is_action_pressed("left-2"):
			position.x -= velocidade * delta
		elif  Input.is_action_pressed("right-2"):
			position.x += velocidade * delta
		elif  Input.is_action_pressed("hit-2"):
			pass


func limit_position():
	position.x = clamp(position.x,440,840)
