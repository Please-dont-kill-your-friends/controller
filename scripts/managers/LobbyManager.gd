extends Node

signal received_id()
signal was_join_successful(successful: bool)

var id: int = -1
var room_code: String = ""

func _ready():
	was_join_successful.connect(_on_was_join_successful)
	pass

func join_lobby():
	WebSocketMessage.msg_req_join()
	pass

func _on_was_join_successful(successful: bool):
	if successful:
		print("Successfully connected to Lobby %s." % [room_code])
		print("Connecting to Servia via WebRTC.")
		WebRTCConnection.create_peer()
	else:
		print("Connection to Lobby %s could not be established." % [room_code])
		# TODO: Show Fail in Screen and Reset Scenes and Variables 
	pass
