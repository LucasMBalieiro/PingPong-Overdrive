extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animation_player = get_node("AnimationPlayer")
	animation_player.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
