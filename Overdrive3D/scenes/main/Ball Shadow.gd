extends Decal

@export
var ball: RigidBody3D
var raycast: RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var child_array: Array = get_children()
	var raycast_pos: int = child_array.find(RayCast3D)
	if raycast_pos == -1:
		raycast = RayCast3D.new()
		raycast.set_target_position(Vector3(0,-4, 0))
	update_position()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_position()
	pass
	
func update_position():
	
	raycast.set_global_position(ball.get_global_position())
	print('ball_pos', ball.global_position)
	print('raycast_pos', raycast.global_position)
	var hit_point = raycast.get_collision_point()
	print('raycast_colision', hit_point)
	set_global_position(hit_point)
	print('updated_decal_pos', global_position)
	
