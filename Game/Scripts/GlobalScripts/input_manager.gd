extends Node

var test = 0

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
	
func get_wii_jump_intensity() -> float:
	if Input.is_action_pressed('Space'):
		return 1
	return 0
	
