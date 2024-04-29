extends Area2D

var velo_bolinha: int = 200
var posicao_saque: Vector2 = Vector2(736, 632)
var direcao: Vector2 = Vector2(0, 0)

#limites da mesa
var x_min: int = 320
var x_max: int = 960

#ultimo que rebateu, usado pra determinar quem "marcou"
var player1_rebate : bool


func _ready():
	pos_saque() 

func _process(delta):
	move_bola(delta)
	colisao()




func move_bola(delta):
	position += direcao * velo_bolinha * delta

#TODO: fazer reset de posição depois de pontuar
func pos_saque():
	position = posicao_saque

func colisao():
	if position.x <= x_min or position.x >= x_max:
		if position.y > 120 and position.y < 600:
			if player1_rebate:
				velo_bolinha = 200
				direcao = Vector2(0, 0)
				position = Vector2(736, 632)
			else:
				velo_bolinha = 200
				direcao = Vector2(0, 0)
				position = Vector2(544, 88)
	
	if position.y <= 40 or position.y >= 680:
		if player1_rebate:
			velo_bolinha = 200
			direcao = Vector2(0, 0)
			position = Vector2(544, 88)
		else:
			velo_bolinha = 200
			direcao = Vector2(0, 0)
			position = Vector2(736, 632)



func _on_body_entered(body):
	if body.is_in_group("Jogadores"):
		var player_position = body.global_position
		var ball_position = global_position
		var collision_normal = (ball_position - player_position).normalized()
		velo_bolinha = velo_bolinha * 1.1
		
		direcao = collision_normal
		
		if body.jogador1:
			player1_rebate = true
		else:
			player1_rebate = false
