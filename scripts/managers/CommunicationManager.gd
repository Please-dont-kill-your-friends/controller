extends Node

signal received_bg_color
signal disable_button_a(disabled: bool)
signal disable_button_b(disabled: bool)

@rpc("any_peer", "call_remote", "reliable")
func client_send_username(_username: String):
	pass

@rpc("any_peer", "call_remote", "unreliable")
func client_send_joystick_input(_vector: Vector2):
	pass

@rpc("any_peer", "call_remote", "unreliable")
func client_send_button_a_input():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func client_send_button_b_input():
	pass

@rpc("authority", "call_remote", "reliable")
func server_send_bg_color(bg_color: Color):
	LobbyManager.bg_color = bg_color
	received_bg_color.emit()
	pass

@rpc("authority", "call_remote", "reliable")
func sever_send_scene_change():
	get_tree().change_scene_to_file("res://scenes/controller/JoystickController.tscn")
	pass

@rpc("authority", "call_remote", "reliable")
func server_disable_button_a(disabled: bool):
	disable_button_a.emit(disabled)
	pass

@rpc("authority", "call_remote", "reliable")
func server_disable_button_b(disabled: bool):
	disable_button_b.emit(disabled)
	pass
