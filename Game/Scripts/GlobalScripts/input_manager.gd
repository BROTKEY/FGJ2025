extends Node

var test = 0
signal wii_jump

signal volume_change
var last_known_volume_value = 0

func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

func _input(event) -> void:
	if event.as_text() == 'Space':
		print(event)
		wii_jump.emit()
		
	if event is InputEventMIDI:
		if event.controller_number == 7:
			last_known_volume_value = event.controller_value
			volume_change.emit(event.controller_value)

func get_soldering_iron_temprature() -> int:
	if Input.is_action_pressed('Space'):
		return 180
	return 0

func get_soldering_iron_shake_state() -> float:
	if Input.is_action_pressed('Up'):
		return 1
	if Input.is_action_pressed('Down'):
		return -1
	return 0

func get_wii_jump() -> float:
	if Input.is_action_pressed('Space'):
		return 1
	return 0

func get_wii_center_of_mass() -> Vector2:
	var board = $WiiboardController
	if board != null and board.board_connected:
		return board.get_center_of_mass()
	return Vector2.ZERO
