extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.register_to_receive_score(show_score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_score(left_score: int, right_score: int):
	text = 'SCORE: ' + str(left_score) + ' X ' + str(right_score)
