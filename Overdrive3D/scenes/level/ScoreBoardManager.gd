extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.register_to_receive_score(show_score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_score(left_player: Dictionary, right_player: Dictionary):
	if left_player.set_points > 0 or right_player.set_points > 0:
		text = '[' + str(left_player.set_points) + '] ' + str(left_player.score) + ' X ' + str(right_player.score) + ' [' + str(right_player.set_points) + ']'
	else:
		text = str(left_player.score) + ' X ' + str(right_player.score)
