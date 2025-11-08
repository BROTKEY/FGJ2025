class_name BaseMicrogame
extends Node2D


enum InputDevice {
	NONE,
	KEYBOARD,
	MOUSE,
	PINECIL,
	MIDI_KEYBOARD,
	WII_BOARD,
	LEAP_MOTION
}


func get_game_name() -> String:
	printerr("Not Implemented!")
	return 'Undefined'

func get_input_device() -> InputDevice:
	printerr("Not Implemented!")
	return InputDevice.NONE

func get_won() -> bool:
	printerr("Not Implemented!")
	return false

func get_difficulty() -> float:
	printerr("Not Implemented!")
	return 1.0

func set_difficulty(_value: float) -> void:
	printerr("Not Implemented!")
