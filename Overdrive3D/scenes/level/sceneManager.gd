extends Node3D

@export var PlayerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
				GameManager.Players[i].player_assigned_number = index
				currentPlayer.register_callback_first_movement($HUD/PlayerControls/RichTextLabel.hide)
		for camera in get_tree().get_nodes_in_group("CameraSpawnPoint"):
			if camera.name == str(index) and !is_multiplayer_authority():
				camera.current = true
		index += 1
	GameManager.build_player_number_to_id_rel()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
