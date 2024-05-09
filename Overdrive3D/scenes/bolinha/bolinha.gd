extends RigidBody3D

var direcao : Vector3 = Vector3(0, 0, 0)
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("bateA_1"):
			apply_central_impulse(Vector3(-0.25, 0.5, -1))


func _on_body_entered(body):
	print("poee")
	if body.is_in_group("Jogadores"):
		if Input.is_action_pressed("bateA_1"):
			apply_central_impulse(Vector3(-0.25, 0.5, -1))

