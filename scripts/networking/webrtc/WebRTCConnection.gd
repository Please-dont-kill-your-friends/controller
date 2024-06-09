extends Node

signal remote_description_received(type: String, sdp: String)
signal ice_candidate_received(media: String, index: int, p_name: String)
signal webrtc_connected

var rtc_mtp: WebRTCMultiplayerPeer = WebRTCMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	remote_description_received.connect(_on_remote_description_received)
	ice_candidate_received.connect(_on_ice_candidate_received)
	pass 

func _process(_delta):
	# print(rtc_mtp.get_connection_status())
	pass

func create_peer():
	var peer: WebRTCPeerConnection = WebRTCPeerConnection.new()
	
	peer.initialize({
		"iceServers": [
			{
				"urls": [ "stun:49.13.224.243:10523" ], # One or more STUN servers.
			},
			{
				"urls": [ "turn:49.13.224.243:10523" ], # One or more TURN servers.
				"username": "test", # Optional username for the TURN server.
				"credential": "test123", # Optional password for the TURN server.
			}
		]
	})
	
	rtc_mtp.create_client(LobbyManager.id)
	multiplayer.multiplayer_peer = rtc_mtp
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	
	peer.session_description_created.connect(_on_session_description_created)
	peer.ice_candidate_created.connect(_on_ice_candidate_created)
	
	rtc_mtp.add_peer(peer, 1)
	peer.create_offer()
	pass

func _on_session_description_created(type: String, sdp: String):
	WebSocketMessage.msg_send_offer(type, sdp)
	_get_peer().set_local_description(type, sdp)
	pass

func _on_remote_description_received(type: String, sdp: String):
	_get_peer().set_remote_description(type, sdp)
	pass

func _on_ice_candidate_created(media: String, index: int, p_name: String):
	WebSocketMessage.msg_send_candidate(media, index, p_name)
	pass

func _on_ice_candidate_received(media: String, index: int, p_name: String):
	_get_peer().add_ice_candidate(media, index, p_name)
	pass

func _on_connected_to_server():
	webrtc_connected.emit()
	pass

func _get_peer() -> WebRTCPeerConnection:
	return rtc_mtp.get_peer(1).connection
