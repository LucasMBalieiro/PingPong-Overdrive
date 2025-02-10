extends Control

@export
var player_number = 0
@export
var is_local = false
var textLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	GameManager.register_to_receive_win(self.show_win,player_number)
	textLabel = $Label
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_win(name):
	if not is_local:
		textLabel.text = name + ' venceu!'
	self.show()
		
