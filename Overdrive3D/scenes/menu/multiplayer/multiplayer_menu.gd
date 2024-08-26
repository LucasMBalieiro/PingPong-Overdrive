extends Control

@export var default_Address = "127.0.0.1"
@export var Address = default_Address
@export var default_port = 8910
@export var port = default_port
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if "--server" in OS.get_cmdline_args():
		hostGame()
		
	$SetName.hide()
	$StartGame.hide()
	
	$Host.show()
	$Join.show()
	
	$SetNetwork/buttonPortHost.hide()
	$SetNetwork/SetPortHost.hide()
	$SetNetwork/PortaHost.hide()
	
	$SetNetwork/IPv4.hide()
	$SetNetwork/SetIpv4.hide()
	$SetNetwork/PortaJoin.hide()
	$SetNetwork/SetPortJoin.hide()
	$SetNetwork/buttonPortJoin.hide()
	
	$PlayerListLabel.hide()
	$PlayerList.hide()
	
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
	var p_name: String = $SetName.text
	if p_name.is_empty():
		p_name = 'Player'
	SendPlayerInformation.rpc_id(1, p_name, 0,multiplayer.get_unique_id())
	print("Connected to Server: " + p_name)

# client only	
func connection_failed():
	print("Connection Failed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc("any_peer")
func SendPlayerInformation(name: String, score: int, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] ={
			"name" : name,
			"id" : id,
			"score": 0,
			"set_points": 0
		}
	else:
		GameManager.Players[id].name = name
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, GameManager.Players[i].score, i)
	draw_player_list()

@rpc("any_peer","call_local")
func StartGame():
	var scene = load("res://scenes/level/main.tscn").instantiate()
	$MenuBG.queue_free()
	get_tree().root.remove_child($MenuBG)
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
	
func draw_player_list():
	$PlayerList.clear()
	for i in GameManager.Players:
		var p_name: String = GameManager.Players[i].name
		if p_name.is_empty():
			p_name = '-'
		$PlayerList.add_item(p_name, null, false)

func _on_host_button_down():
	$Host.hide()
	$Join.hide()
	$SetNetwork/buttonPortHost.show()
	$SetNetwork/SetPortHost.show()
	$SetNetwork/PortaHost.show()
	pass 


func _on_join_button_down():
	$Host.hide()
	$Join.hide()
	
	$SetNetwork/IPv4.show()
	$SetNetwork/SetIpv4.show()
	$SetNetwork/PortaJoin.show()
	$SetNetwork/SetPortJoin.show()
	$SetNetwork/buttonPortJoin.show()
	pass # Replace with function body.


func _on_start_game_button_down():
	StartGame.rpc()
	pass # Replace with function body.

func _on_button_port_join_button_down():
	Address = $SetNetwork/SetIpv4.text
	port = int($SetNetwork/SetPortJoin.text)
	
	if Address.is_empty():
		Address = default_Address
	if port == 0:
		port = default_port
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
	$SetNetwork/IPv4.hide()
	$SetNetwork/SetIpv4.hide()
	$SetNetwork/PortaJoin.hide()
	$SetNetwork/SetPortJoin.hide()
	$SetNetwork/buttonPortJoin.hide()
	$SetName.show()
	$StartGame.show()
	$PlayerListLabel.show()
	$PlayerList.show()

func _on_button_port_host_button_down():
	port = int($SetNetwork/SetPortHost.text)
	if port == 0:
		port = default_port
		
	hostGame()
	SendPlayerInformation('Player', 0,multiplayer.get_unique_id())
	print("Game hosted: " + 'Player')
	
	$SetNetwork/buttonPortHost.hide()
	$SetNetwork/SetPortHost.hide()
	$SetNetwork/PortaHost.hide()
	$SetName.show()
	$StartGame.show()
	$PlayerListLabel.show()
	$PlayerList.show()

func _on_set_name_change(new_name: String):
	var p_name: String = new_name
	if p_name.is_empty():
		p_name = 'Player'
	if multiplayer.is_server():
		SendPlayerInformation.rpc(p_name, 0, multiplayer.get_unique_id())
		GameManager.Players[multiplayer.get_unique_id()].name = p_name
		draw_player_list()
	else:
		SendPlayerInformation.rpc_id(1, p_name, 0,multiplayer.get_unique_id())
