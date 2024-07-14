extends RayCast3D

@export
var shadow_decal: Decal
@export
var ball: RigidBody3D
@export
var scale_factor: float = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_shadow_pos()
	pass
	
func update_shadow_pos():
	set_global_position(ball.get_global_position())
	var collision: Vector3 = get_collision_point()
	var decal_world_height: float = shadow_decal.get_size().y/2 + collision.y
	var collision_y: float
	if ball.get_global_position().y < decal_world_height:
		collision_y = collision.y - (decal_world_height - ball.get_global_position().y)
	else:
		collision_y = collision.y
	shadow_decal.set_global_position(Vector3(collision.x, collision_y, collision.z))
	
	var distance: float = ball.get_global_position().y - collision_y
	var scale: float = (100 - distance * scale_factor)/500
	shadow_decal.set_size(Vector3(scale, 1, scale))
	
	print({"ball_pos": ball.get_global_position(), 
	"ray_pos": get_global_position(),
	"decal_size": decal_world_height,
	"collision": collision, 
	"shadow_pos": shadow_decal.get_global_position()})
