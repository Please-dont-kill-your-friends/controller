extends Node

signal received_bg_color

@rpc("any_peer", "call_remote", "reliable")
func client_send_username(_username: String):
	pass

@rpc("authority", "call_remote", "reliable")
func server_send_bg_color(bg_color: Color):
	LobbyManager.bg_color = bg_color
	received_bg_color.emit()
	pass
