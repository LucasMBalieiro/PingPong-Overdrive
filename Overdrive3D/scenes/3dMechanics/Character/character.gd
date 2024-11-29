extends CharacterBody3D
class_name player
var collision_shape: CollisionShape3D
var animation_player: AnimationPlayer
var rng: RandomNumberGenerator
var animation_time: float

var SPEED = 5.0

var player1: bool
var dashing = false
var can_dash = true
var can_hit = true
@onready var hitsound = $hitsound

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	fix_rotation.rpc()
	animation_player = get_node("Carlos Kano 3D2/AnimationPlayer")
	animation_player.play('idle', 1, 0.25)
	rng = RandomNumberGenerator.new()
	animation_time = 0

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		movimentacao(delta)
		move_border()
		bater()


func movimentacao(delta):
	var moved = false
	var reverse_play = false
	if Input.is_action_just_pressed("dash_1") and can_dash:
		dash()
		moved = true
	if Input.is_action_pressed("esq_1"):
		if player1:
			position += (Vector3(-1 , 0 , 0) * SPEED * delta)
		else:
			position += (Vector3(1 , 0 , 0) * SPEED * delta)
		moved = true
	elif Input.is_action_pressed("dir_1"):
		if player1:
			position += (Vector3(1 , 0 , 0) * SPEED * delta)
			reverse_play = true
		else:
			position += (Vector3(-1 , 0 , 0) * SPEED * delta)
		moved = true
	if moved and (not animation_player.is_playing() or animation_player.current_animation == 'idle'):
		if animation_player.current_animation != 'walking':
			if reverse_play:
				animation_player.play_backwards('walking')
			else:
				animation_player.play('walking')
		else:
			if reverse_play:
				animation_player.play_backwards()
			else:
				animation_player.play()
	
	var check_for_idle = false
	if not moved and animation_player.current_animation == 'walking':
		check_for_idle = true
	if animation_player.current_animation not in ['walking', 'idle'] and not animation_player.is_playing():
		check_for_idle = true
	
	if moved:
		animation_time = 0
	if check_for_idle:
		animation_time += delta
		animation_player.pause()
		if animation_time > 0.25:
			animation_player.play("", -1, 0.0001)
			animation_player.play('idle', 1, 0.25)
			
	pass

func move_border():
	position.x = clamp(position.x, -4, 4)

func dash():
	can_dash = false
	dashing = true
	$Dashing.start()
	$Can_dash.start()
	SPEED = SPEED * 4

func hit_time():
	can_hit = false
	hitsound_play.rpc()
	$Can_hit.start()

func bater():
	var bodies = $HitBox.get_overlapping_bodies()
	
	var play_animation = false
	var play_backhand = false
	for bolinha in bodies:
		if (bolinha.has_method("move_bolinha") and can_hit):
			if Input.is_action_just_pressed("bateA_1"):
				bolinha.move_bolinha.rpc(player1, "A")
				play_animation = true
				play_backhand = false
				hit_time()
			if Input.is_action_just_pressed("bateB_1"):
				bolinha.move_bolinha.rpc(player1, "B")
				play_animation = true
				play_backhand = rng.randi_range(0,1) == 1
				hit_time()
			if Input.is_action_just_pressed("bateC_1"):
				bolinha.move_bolinha.rpc(player1, "C")
				hit_time()
				play_animation = true
				play_backhand = true
	
	if play_animation and animation_player.current_animation not in ['Backahand', 'forehand']:
		if play_backhand:
			animation_player.play('Backahand')
		else:
			animation_player.play('forehand')

@rpc("any_peer", "call_local")
func fix_rotation():
	if position.z > 0:
		player1 = true
		set_rotation_degrees(Vector3(0, 90, 0))
	else:
		player1 = false
		set_rotation_degrees(Vector3(0, -90, 0))

@rpc("any_peer", "call_local")
func hitsound_play():
	hitsound.play()

func _on_can_dash_timeout():
	can_dash = true

func _on_dashing_timeout():
	SPEED = SPEED / 4
	dashing = false

func _on_can_hit_timeout():
	can_hit = true
