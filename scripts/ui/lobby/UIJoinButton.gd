extends Button

func _on_pressed():
	var room_code: String = $"../CodeInput".text
	var username: String = $"../NameInput".text
	
	if username == "" || room_code == "" || room_code.length() != 4:
		return
	
	disabled = true
	LobbyManager.room_code = room_code
	LobbyManager.username = username
	LobbyManager.join_lobby()
	pass
