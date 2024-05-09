extends CharacterBody3D
class_name player
var collision_shape: CollisionShape3D

const _movespeed = 5.0
const DASHSPEED = _movespeed * 4
var SPEED = 5.0


var last_hit_time = 0.0
const hit_cooldown = 1000

@export var player1 = true
var dashing = false
var can_dash = true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	collision_shape = $CollisionShape3D
	collision_shape.disabled = true 


func _physics_process(delta):
	
	movimentacao(delta)
	print(last_hit_time)
	move_border()
	hitbox()


func movimentacao(delta):
	if player1:
		if Input.is_action_just_pressed("dash_1") and can_dash:
				dash()
		if Input.is_action_pressed("esq_1"):
			position += (Vector3(-1 , 0 , 0) * SPEED * delta)
			
		elif Input.is_action_pressed("dir_1"):
			position += (Vector3(1 , 0 , 0) * SPEED * delta)
	else:
		if Input.is_action_just_pressed("dash_2") and can_dash:
				dash()
		if Input.is_action_pressed("esq_2"):
			position += (Vector3(-1 , 0 , 0) * SPEED * delta)
		elif Input.is_action_pressed("dir_2"):
			position += (Vector3(1 , 0 , 0) * SPEED * delta)


func move_border():
	position.x = clamp(position.x, -4, 4)


func dash():
	can_dash = false
	dashing = true
	$Dashing.start()
	$Can_dash.start()
	print("dash start")
	SPEED = DASHSPEED

func _on_can_dash_timeout():
	can_dash = true
	print("can_dash")


func _on_dashing_timeout():
	SPEED = _movespeed
	dashing = false

func hitbox():
	if  (Input.is_action_pressed("bateA_1") and can_hit()):
		collision_shape.disabled = false
		print("hitbox ativa")
		last_hit_time = Time.get_ticks_msec() / 1000.0 
	elif not (Input.is_action_pressed("bateA_1") or Input.is_action_pressed("bateB_1") or Input.is_action_pressed("bateC_1")):
		collision_shape.disabled = true
# COLINHA

func can_hit():
	return Time.get_ticks_msec() / 1000.0 - last_hit_time >= hit_cooldown

