extends Node

# Enum of all Message Types that can be send
enum MessageType{
	Id,
	Join,
	UserConnected,
	UserDisconnected,
	Lobby,
	Candidate,
	Offer,
	Answer,
	CheckIn
}

# Receives the message and processes it based on it's message type
func handle_message(message: String):
	var data: Dictionary = JSON.parse_string(message)
	var type: MessageType = int(data["type"])
	
	match type:
		MessageType.Id:
			_handle_id_msg(data)
		MessageType.Join:
			_handle_join_msg(data)
		MessageType.Answer:
			_handle_answer_msg(data)
		MessageType.Candidate:
			_handle_candidate_msg(data)
	pass

# Build JSON strings to send to the server
func _build_message(type: MessageType, payload: Dictionary = {}, id: int = -1) -> String:
	var message = {
		"type": type,
		"room_code": LobbyManager.room_code,
		"id": id,
		"server": false,
		"payload": payload
	}
	return JSON.stringify(message)

# Send Message
func _send_message(message: String):
	WebSocketConnection.socket.send_text(message)
	pass

# Handle each type of message the game can receive
func _handle_id_msg(data: Dictionary):
	var id: int = int(data.id)
	print("Received id %s." % [id])
	LobbyManager.id = id
	LobbyManager.received_id.emit()
	pass

func _handle_join_msg(data: Dictionary):
	var succcessful: bool = bool(data.payload.successful)
	LobbyManager.was_join_successful.emit(succcessful)
	pass

func _handle_answer_msg(data: Dictionary):
	WebRTCConnection.remote_description_received.emit(data.payload.type, data.payload.sdp)
	pass

func _handle_candidate_msg(data: Dictionary):
	WebRTCConnection.ice_candidate_received.emit(data.payload.media, data.payload.index, data.payload.name)
	pass

# Predefined functions to make the way of building messages easier
func msg_get_id() -> void:
	var message: String = _build_message(MessageType.Id)
	_send_message(message)
	pass

func msg_req_join() -> void:
	var message: String = _build_message(MessageType.Join, { "room_code": LobbyManager.room_code }, LobbyManager.id)
	_send_message(message)
	pass

func msg_send_offer(type: String, sdp: String) -> void:
	var message: String = _build_message(MessageType.Offer, { "type": type, "sdp": sdp }, LobbyManager.id)
	_send_message(message)
	pass

func msg_send_candidate(media: String, index: int, p_name: String) -> void:
	var message: String = _build_message(MessageType.Candidate, { "media": media, "index": index, "name": p_name }, LobbyManager.id)
	_send_message(message)
	pass
