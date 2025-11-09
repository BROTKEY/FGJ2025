extends Node


enum InputDevice {
	NONE,
	KEYBOARD,
	MOUSE,
	PINECIL,
	MIDI_KEYBOARD,
	WII_BOARD,
	LEAP_MOTION
}

const PinecilMenus = preload("res://Scripts/Types/pinecil_types.gd").PinecilMenus


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


## Check if a Device is generally available (i.e., if the required libs are installed)
func is_device_available(device: InputDevice) -> bool:
	match device:
		InputDevice.NONE:
			return false
		InputDevice.KEYBOARD, InputDevice.MOUSE, InputDevice.MIDI_KEYBOARD:
			return true
		InputDevice.PINECIL:
			return $Pinecil != null and $Pinecil.pinecil_lib_loaded
		InputDevice.WII_BOARD:
			return $WiiboardController != null and $WiiboardController.wiiboard_lib_loaded
		InputDevice.LEAP_MOTION:
			return false
		_:
			return false


## Check if a Device is currently connected and ready to use
func is_device_connected(device: InputDevice):
	match device:
		InputDevice.NONE:
			return false
		InputDevice.KEYBOARD, InputDevice.MOUSE:
			return true
		InputDevice.MIDI_KEYBOARD:
			return len(OS.get_connected_midi_inputs()) > 0
		InputDevice.PINECIL:
			return $Pinecil != null and $Pinecil.pinecil_connected
		InputDevice.WII_BOARD:
			return $WiiboardController != null and $WiiboardController.board_connected
		InputDevice.LEAP_MOTION:
			return false
		_:
			return false


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

func set_soldering_iron_screen(screen: PinecilMenus):
	pass

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
