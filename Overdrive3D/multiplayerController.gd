extends Control

@export var address = "127.0.0.1"
@export var port = 8910
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.disconnect(peer_disconnected)
	multiplayer.connected_to_server.disconnect(connected_to_server)
	multiplayer.connection_failed.disconnect(connection_failed)
	pass # Replace with function body.

func _process(delta):
	pass

#chama no server e no client
func peer_connected(id):
	print("peer_connected:" + str(id))

#chama no server e no client
func peer_disconnected(id):
	print("peer_disconnected:" + str(id))

#chama no client
func connected_to_server():
	print("connected_to_server")
	sendPlayerInfo.rpc_id(1, $NameLabel.text, multiplayer.get_unique_id())

#chama no client
func connection_failed():
	print("connection_failed:")

@rpc("any_peer", "call_local")
func startGame():
	var scene = load("res://scenes/main/main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

@rpc("any_peer")
func sendPlayerInfo(name, id):
	if !GameMaster.Players.has(id):
		GameMaster.Players[id] = {"name" : name, "id" : id, "score" : 0}
	
	if multiplayer.is_server():
		for i in GameMaster.Players:
			sendPlayerInfo.rpc(GameMaster.Players[i].name, i)

func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	
	if error != OK:
		print("Host fail: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Esperando oponente")
	sendPlayerInfo($NameLabel.text, multiplayer.get_unique_id())


func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)


func _on_start_game_button_down():
	startGame.rpc()
