extends Node

var test = 0
signal wii_jump

signal volume_change
var last_known_volume_value = 0

func _ready() -> void:
	OS.open_midi_inputs()
	print("MIDI Devices: ", OS.get_connected_midi_inputs())
	var wiiboard = $WiiboardController
	if wiiboard == null:
		print("No WiiboardController!")
	else:
		wiiboard.jump.connect(_on_wiiboard_jump)

func _input(event) -> void:
	if event.as_text() == 'Space':
		wii_jump.emit()
		
	if event is InputEventMIDI:
		if event.controller_number == 7:
			last_known_volume_value = event.controller_value
			volume_change.emit(event.controller_value)

func _on_wiiboard_jump() -> void:
	wii_jump.emit()

func get_soldering_iron_temprature() -> int:
	var temperature = 0
	if Time.get_ticks_msec() % 50:
		var pinecil_temp = $Pinecil.get_current_temperature()
		if pinecil_temp != -1:
			temperature = pinecil_temp
	if Input.is_action_pressed('Space'):
		temperature = 180
	return temperature
	
func get_soldering_iron_shake_state() -> float:
	var shake_state = 0
	
	if Time.get_ticks_msec() % 20:
		var pinecil_accel_value = $Pinecil.get_accelerometer_value_x()
		if abs(pinecil_accel_value) > 20000:
			shake_state = pinecil_accel_value / abs(pinecil_accel_value)
	
	if Input.is_action_pressed('Up'):
		shake_state = 1
	if Input.is_action_pressed('Down'):
		shake_state = -1 
	return shake_state

func get_wii_jump() -> float:
	# TODO: remove
	if Input.is_action_pressed('Space'):
		return 1
	return 0

func get_wii_center_of_mass() -> Vector2:
	var board = $WiiboardController
	if board != null and board.board_connected:
		return board.get_center_of_mass()
	return Vector2.ZERO
