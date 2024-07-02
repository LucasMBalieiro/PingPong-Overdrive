extends Control

@export var Address = "0.0.0.0"
@export var port = 8910
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if "--server" in OS.get_cmdline_args():
		hostGame()
	pass # Replace with function body.

# chama server e client
func peer_connected(id):
	print("Player Connected: " + str(id))
	
# chama server e client
func peer_disconnected(id):
	print("Player Disconnected: " + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Jogadores")
	for i in players:
		if i.name == str(id):
			i.queue_free()
	
# client only
func connected_to_server():
	SendPlayerInformation.rpc_id(1, $SetName.text, multiplayer.get_unique_id())
	print("Connected to Server: " + $SetName.text)

# client only	
func connection_failed():
	print("Connection Failed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] ={
			"name" : name,
			"id" : id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)


@rpc("any_peer","call_local")
func StartGame():
	var scene = load("res://scenes/level/main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("host ERROR: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Host ligado")

func _on_host_button_down():
	hostGame()
	SendPlayerInformation($SetName.text, multiplayer.get_unique_id())
	print("Game hosted: " + $SetName.text)
	pass 


func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)	
	pass # Replace with function body.


func _on_start_game_button_down():
	StartGame.rpc()
	pass # Replace with function body.


func _on_button_ip_button_down():
	Address = $SetNetwork/SetIpv4.text


func _on_button_port_button_down():
	port = int($SetNetwork/SetPort.text)
