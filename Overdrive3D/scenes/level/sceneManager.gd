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
		
		for camera in get_tree().get_nodes_in_group("CameraSpawnPoint"):
			if camera.name == str(index) and !is_multiplayer_authority():
				camera.current = true
		index += 1
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
