extends Node
	
func get_soldering_iron_temprature() -> int:
	if Input.is_action_pressed('Space'):
		return 180
	return 0
