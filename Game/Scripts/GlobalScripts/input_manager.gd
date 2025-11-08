extends Node

var test = 0

func get_soldering_iron_temprature() -> int:
	var temperature = 0
	var pinecil_temp = $Pinecil.get_current_temperature()
	if pinecil_temp != -1:
		temperature = pinecil_temp
	if Input.is_action_pressed('Space'):
		temperature = 180
	return temperature
	
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
	
