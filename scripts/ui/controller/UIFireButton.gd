extends Control

func _ready():
	CommunicationManager.disable_button_a.connect(_on_disable_button_a)
	pass

func _on_button_pressed():
	CommunicationManager.client_send_button_a_input.rpc_id(1)
	$Button.disabled = true
	pass 

func _on_disable_button_a(disabled: bool):
	$Button.disabled = disabled
	pass
