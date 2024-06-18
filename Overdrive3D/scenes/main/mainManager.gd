extends Node3D

@export var PlayerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameMaster.Players:
		var currentPlayer = PlayerScene.instantiate()
		add_child(currentPlayer)
		
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
				currentPlayer.global_rotation = spawn.global_rotation
				currentPlayer.player1 = !index
		index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in GameMaster.Players:
		print(i)
