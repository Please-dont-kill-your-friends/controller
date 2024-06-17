extends Control

# Vectors to calculate the curent direction
var dirVector: Vector2 = Vector2(0, 0)
var currVector: Vector2 = Vector2(0, 0)
var offsetVector: Vector2 = Vector2(215, 215)

var is_pressed: bool = false
var max_length: int = 200
var deadzone: int = 5
var cap_count = 6
var cap_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	max_length *= scale.x
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_current_vector(delta)
	send_capped_output()
	pass

func update_current_vector(delta: float):
	var mouse_position: Vector2 = get_global_mouse_position()
	
	if is_pressed:
		if mouse_position.distance_to(global_position + offsetVector) <= max_length:
			$Knob.global_position = mouse_position
		else:
			var angle = (global_position + offsetVector).angle_to_point(mouse_position)
			$Knob.global_position = global_position + Vector2(cos(angle), sin(angle)) * max_length + offsetVector
		currVector = calculateVector()
	else:
		$Knob.global_position = lerp($Knob.global_position, global_position + offsetVector, 20 * delta)
		currVector = Vector2(0,0)
	pass

# To avoid overloading the server with too many packets, filter the output
# Always send the vector (0, 0)
# Only send packets with vectors that differ from the previous one
# Limit the sending rate to a maximum of 10 packets per second (60 frames / 6)
func send_capped_output():
	if currVector == dirVector:
		return
	
	if currVector == Vector2(0,0):
		dirVector = currVector
		CommunicationManager.client_send_joystick_input.rpc_id(1, dirVector)
	
	if cap_counter < cap_count:
		cap_counter += 1
		return
	
	cap_counter = 0
	dirVector = currVector
	CommunicationManager.client_send_joystick_input.rpc_id(1, dirVector)
	pass

func calculateVector() -> Vector2:
	var diff = $Knob.global_position - global_position - offsetVector
	var vector = Vector2(
		diff.x / max_length if abs(diff.x) >= deadzone else 0,
		diff.y / max_length if abs(diff.y) >= deadzone else 0
	)
	return vector

func _on_holding_button_button_down():
	is_pressed = true
	pass 

func _on_holding_button_button_up():
	is_pressed = false
	pass
