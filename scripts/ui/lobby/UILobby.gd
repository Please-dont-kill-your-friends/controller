extends Control

var start_scene: PackedScene = load("res://scenes/lobby/Start.tscn")
var join_scene: PackedScene = load("res://scenes/lobby/Join.tscn")
var connected_scene: PackedScene = load("res://scenes/lobby/Connected.tscn")

var start_instance: Node
var join_instance: Node
var connected_instance: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	WebSocketConnection.connected_to_server.connect(_on_connected_to_server)
	WebRTCConnection.webrtc_connected.connect(_on_webrtc_connected)
	
	start_instance = start_scene.instantiate()
	add_child(start_instance)
	pass

func _on_connected_to_server():
	start_instance.queue_free()
	join_instance = join_scene.instantiate()
	add_child(join_instance)
	pass

func _on_webrtc_connected():
	join_instance.queue_free()
	connected_instance = connected_scene.instantiate()
	add_child(connected_instance)
	pass
