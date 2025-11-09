extends Node2D

var Pinecil = InputManager.get_node("Pinecil")
const PinecilMenus = preload("res://Scripts/Types/pinecil_types.gd").PinecilMenus

func _process(_delta: float) -> void:
	if !(Time.get_ticks_msec() % 100):
		return
		
	var lib_status = "Missing"
	if Pinecil.pinecil_lib_loaded:
		lib_status = "Existing"
	$GridContainer/VBoxContainer2/PinecilLibStatus.text = lib_status
	
	var con_status = "Disconnected"
	if Pinecil.pinecil_connected:
		con_status = "Connected"
	$GridContainer/VBoxContainer2/PinecilConnected.text = con_status

func _on_main_menu_pressed() -> void:
	InputManager.set_soldering_iron_screen(PinecilMenus.GameJamHome)

func _on_temp_adjust_pressed() -> void:
	InputManager.set_soldering_iron_screen(PinecilMenus.GameJamTemperatureAdjist)

func _on_shake_menu_pressed() -> void:
	InputManager.set_soldering_iron_screen(PinecilMenus.GameJamShake)

func _on_get_screen_pressed() -> void:
	var screen = InputManager.get_soldering_iron_screen()
	print(screen)
