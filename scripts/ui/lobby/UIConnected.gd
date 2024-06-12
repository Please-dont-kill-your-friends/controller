extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$WelcomeLabel.text += LobbyManager.room_code + ", " + LobbyManager.username+ "!"
	pass
