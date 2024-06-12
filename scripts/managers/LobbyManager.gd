extends Node

signal received_id(id: int)
signal was_join_successful(successful: bool)

var id: int = -1
var room_code: String = ""
var username: String = ""
var bg_color: Color = Color(0.24, 0.24, 0.24)

func _ready():
	was_join_successful.connect(_on_was_join_successful)
	WebRTCConnection.webrtc_connected.connect(_on_webrtc_connected)
	pass

func join_lobby():
	WebSocketMessage.msg_req_join()
	pass

func _on_was_join_successful(successful: bool):
	if successful:
		print("Successfully connected to Lobby %s.\nConnecting to Game via WebRTC." % [room_code])
		WebRTCConnection.start_connection()
	else:
		print("Connection to Lobby %s could not be established." % [room_code])
		# TODO: Show Fail in Screen and Reset Scenes and Variables 
	pass

func _on_webrtc_connected():
	CommunicationManager.client_send_username.rpc_id(1, username)
