extends Button

var iconHover = preload("res://resources/sprites/PingPongMenuHover.png")
var iconNormal = preload("res://resources/sprites/PingPongMenuDefault.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.icon.emit_changed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	print('Mouse entrou')
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	print('Mouse saiu')
	pass # Replace with function body.
