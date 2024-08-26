extends MeshInstance3D

var gravity: float = 9.8
var speed: float = 0
var floor_height = 0.2
var start_pos = 1.4
var final_velocity = sqrt(2*gravity*(start_pos - floor_height))
@onready var hitsound = $hitsound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = start_pos
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y < floor_height:
		speed = final_velocity
		hitsound.play()
	speed = speed - (gravity * delta)
	position.y = position.y + (speed * delta)
	pass
