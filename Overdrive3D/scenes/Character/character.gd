extends CharacterBody3D
var collision_shape: CollisionShape3D

@onready var hitbox = $HitBox

@export var SPEED = 5.0
const _movespeed = 5.0
const DASHSPEED = _movespeed * 4


@export var player1 = true
var dashing = false
var can_dash = true
var can_hit = true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass


func _physics_process(delta):
	
	movimentacao(delta)
	move_border()
	bater()


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
	position.x = clamp(position.x, -4.5, 4.5)

func dash():
	can_dash = false
	dashing = true
	$Dashing.start()
	$Can_dash.start()
	SPEED = DASHSPEED

func hit_time():
	can_hit = false
	$Can_hit.start()

func bater():
	var bodies = hitbox.get_overlapping_bodies()
	
	for bolinha in bodies:
		if (bolinha.has_method("move_bolinha") and can_hit):
			if player1:
				if Input.is_action_just_pressed("bateA_1"):
					bolinha.move_bolinha(player1, "A")
					hit_time()
				if Input.is_action_just_pressed("bateB_1"):
					bolinha.move_bolinha(player1, "B")
					hit_time()
				if Input.is_action_just_pressed("bateC_1"):
					bolinha.move_bolinha(player1, "C")
					hit_time()
			else:
				if Input.is_action_just_pressed("bateA_2"):
					bolinha.move_bolinha(player1, "A")
					hit_time()
				if Input.is_action_just_pressed("bateB_2"):
					bolinha.move_bolinha(player1, "B")
					hit_time()
				if Input.is_action_just_pressed("bateC_2"):
					bolinha.move_bolinha(player1, "C")
					hit_time()

func _on_can_dash_timeout():
	can_dash = true

func _on_dashing_timeout():
	SPEED = _movespeed
	dashing = false

func _on_can_hit_timeout():
	can_hit = true
