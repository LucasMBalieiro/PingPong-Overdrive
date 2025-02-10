extends CharacterBody3D
var collision_shape: CollisionShape3D
var animation_player: AnimationPlayer
var rng: RandomNumberGenerator
var animation_time: float

var SPEED = 5.0
var mapping

var set_p1: bool
var player1: bool
var dashing = false
var can_dash = true
var can_hit = true
var already_movemented
@onready var hitsound = $hitsound
var first_movement_callback

func _ready():
	# fix_rotation()
	set_p1 = false
	already_movemented = false
	animation_player = get_node("Carlos Kano 3D2/AnimationPlayer")
	animation_player.play('idle', 1, 0.25)
	rng = RandomNumberGenerator.new()
	animation_time = 0

func _physics_process(delta):
		movimentacao(delta)
		move_border()
		bater()


func movimentacao(delta):
	fix_rotation()
	var moved = false
	var reverse_play = false
	if Input.is_action_just_pressed(mapping['dash']) and can_dash:
		dash()
		moved = true
	if Input.is_action_pressed(mapping['esq']):
		if player1:
			position += (Vector3(-1 , 0 , 0) * SPEED * delta)
		else:
			position += (Vector3(1 , 0 , 0) * SPEED * delta)
		moved = true
	elif Input.is_action_pressed(mapping['dir']):
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
		has_movemented()
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
	hitsound_play()
	$Can_hit.start()

func bater():
	var bodies = $HitBox.get_overlapping_bodies()
	
	var play_animation = false
	var play_backhand = false
	for bolinha in bodies:
		if (bolinha.has_method("move_bolinha") and can_hit):
			if Input.is_action_just_pressed(mapping['bateA']):
				bolinha.move_bolinha(player1, "A")
				play_animation = true
				play_backhand = false
				hit_time()
			if Input.is_action_just_pressed(mapping['bateB']):
				bolinha.move_bolinha(player1, "B")
				play_animation = true
				play_backhand = rng.randi_range(0,1) == 1
				hit_time()
			if Input.is_action_just_pressed(mapping['bateC']):
				bolinha.move_bolinha(player1, "C")
				hit_time()
				play_animation = true
				play_backhand = true
	
	if play_animation and animation_player.current_animation not in ['Backahand', 'forehand']:
		if play_backhand:
			animation_player.play('Backahand')
		else:
			animation_player.play('forehand')

func fix_rotation():
	if not set_p1:
		if position.z > 5:
			player1 = true
			set_rotation_degrees(Vector3(0, 90, 0))
			print('set player 1', position)
			mapping = {
				'esq': 'esq_2',
				'dir': 'dir_2',
				'dash': 'dash_2',
				'bateA': 'bateA_2',
				'bateB': 'bateB_2',
				'bateC': 'bateC_2'
			}
		else:
			player1 = false
			set_rotation_degrees(Vector3(0, -90, 0))
			print('set player 2', position)
			mapping = {
				'esq': 'esq_3',
				'dir': 'dir_3',
				'dash': 'dash_3',
				'bateA': 'bateA_3',
				'bateB': 'bateB_3',
				'bateC': 'bateC_3'
			}
		set_p1 = true

func hitsound_play():
	hitsound.play()
	
func has_movemented() -> void:
	if already_movemented:
		return
	
	already_movemented = true
	first_movement_callback.call()
		
func register_callback_first_movement(callback):
	first_movement_callback = callback

func _on_can_dash_timeout():
	can_dash = true

func _on_dashing_timeout():
	SPEED = SPEED / 4
	dashing = false

func _on_can_hit_timeout():
	can_hit = true
