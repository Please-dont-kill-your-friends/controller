extends Control

func _ready():
	WebSocketConnection.connected_to_server.connect(_on_connected_to_server)
	WebRTCConnection.webrtc_connected.connect(_on_webrtc_connected)
	pass

func _on_connect_button_pressed():
	WebSocketConnection.connect_to_signaling_server()
	$StartConnection.visible = false;
	pass 

func _on_join_button_pressed():
	var room_code: String = $JoinLobby/CodeInput.text
	$JoinLobby/JoinButton.disabled = true
	LobbyManager.room_code = room_code
	LobbyManager.join_lobby()
	pass

func _on_connected_to_server():
	$JoinLobby.visible = true
	pass

func _on_webrtc_connected():
	$Connected/IdLabel.text = "ID: " + str(LobbyManager.id)
	$JoinLobby.visible = false
	$Connected.visible = true
