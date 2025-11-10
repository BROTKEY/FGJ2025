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

const DeviceDisplayNames = {
	InputDevice.NONE: "None",
	InputDevice.KEYBOARD: "Keyboard",
	InputDevice.MOUSE: "Mouse",
	InputDevice.PINECIL: "Pinecil",
	InputDevice.MIDI_KEYBOARD: "MIDI Keyboard",
	InputDevice.WII_BOARD: "Wii Fit BalanceBoard",
	InputDevice.LEAP_MOTION: "Hand Tracker",
}

const PinecilMenus = preload("res://Scripts/Common/pinecil_types.gd").PinecilMenus

const pinecil_debugger = preload("res://Scenes/Debug/PinecilDebug.tscn")

var test = 0
signal wii_jump

signal volume_change
var last_known_volume_value = 0

signal keystroke

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
			#print('volume = ', last_known_volume_value)
			volume_change.emit(event.controller_value)
		
		if event.message ==9:
			print(event)
			keystroke.emit(event.pitch%12, event.velocity != 0)
	
	elif event is InputEventKey:
		if event.keycode == 80: # 'P'
			SceneManager.set_current_scene(pinecil_debugger.instantiate())

func _print_midi_info(midi_event):
	print(midi_event)
	print("Channel ", midi_event.channel)
	print("Message ", midi_event.message)
	print("Pitch ", midi_event.pitch)
	print("Velocity ", midi_event.velocity)
	print("Instrument ", midi_event.instrument)
	print("Pressure ", midi_event.pressure)
	print("Controller number: ", midi_event.controller_number)
	print("Controller value: ", midi_event.controller_value)

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
	var pinecil_temp = $Pinecil.get_current_temperature()
	if pinecil_temp != -1:
		temperature = pinecil_temp
	if Input.is_action_pressed('Space'):
		temperature = 180
	return temperature
	
func get_soldering_iron_shake_state() -> float:
	var shake_state = 0
	
	var pinecil_accel_value = $Pinecil.get_accelerometer_value_x()
	if abs(pinecil_accel_value) > 20000:
		shake_state = pinecil_accel_value / abs(pinecil_accel_value)
	
	if Input.is_action_pressed('Up'):
		shake_state = 1
	if Input.is_action_pressed('Down'):
		shake_state = -1 
	return shake_state

func get_soldering_iron_screen():
	return $Pinecil.get_current_menu()

func set_soldering_iron_screen(screen: PinecilMenus):
	$Pinecil.change_menu(screen)

func set_soldering_iron_temperature(temperature: int):
	$Pinecil.set_temperature(temperature)

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
