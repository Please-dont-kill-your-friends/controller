extends TextureRect

func _ready():
	CommunicationManager.received_bg_color.connect(_on_received_bg_color)
	modulate = LobbyManager.bg_color
	pass 

func _on_received_bg_color():
	modulate = LobbyManager.bg_color
	pass
