extends CharacterBody3D
class_name player
var collision_shape: CollisionShape3D

const _movespeed = 5.0
const DASHSPEED = _movespeed * 4
var SPEED = 5.0

var player1
var dashing = false
var can_dash = true
var can_hit = true


func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	fix_rotation.rpc()


func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		movimentacao(delta)
		move_border()
		bater.rpc()


func movimentacao(delta):
	if Input.is_action_just_pressed("dash_1") and can_dash:
				dash()
	if Input.is_action_pressed("esq_1"):
		position += (Vector3(-1 , 0 , 0) * SPEED * delta)
		
	elif Input.is_action_pressed("dir_1"):
		position += (Vector3(1 , 0 , 0) * SPEED * delta)

func move_border():
	position.x = clamp(position.x, -4, 4)

func dash():
	can_dash = false
	dashing = true
	$Dashing.start()
	$Can_dash.start()
	SPEED = DASHSPEED

func hit_time():
	can_hit = false
	$Can_hit.start()

@rpc("any_peer", "call_local")
func bater():
	var bodies = $HitBox.get_overlapping_bodies()
	
	for bolinha in bodies:
		if (bolinha.has_method("move_bolinha") and can_hit):
			if Input.is_action_just_pressed("bateA_1"):
				bolinha.move_bolinha.rpc(player1, "A")
				hit_time()
			if Input.is_action_just_pressed("bateB_1"):
				bolinha.move_bolinha.rpc(player1, "B")
				hit_time()
			if Input.is_action_just_pressed("bateC_1"):
				bolinha.move_bolinha.rpc(player1, "C")
				hit_time()

@rpc("any_peer", "call_local")
func fix_rotation():
	if position.z > 0:
		player1 = true
		set_rotation_degrees(Vector3(0, 90, 0))
	else:
		player1 = false
		set_rotation_degrees(Vector3(0, -90, 0))

func _on_can_dash_timeout():
	can_dash = true

func _on_dashing_timeout():
	SPEED = _movespeed
	dashing = false

func _on_can_hit_timeout():
	can_hit = true
