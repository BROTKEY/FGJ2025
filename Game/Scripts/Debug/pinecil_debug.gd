extends Node2D

var Pinecil = InputManager.get_node("Pinecil")
const PinecilMenus = preload("res://Scripts/Types/pinecil_types.gd").PinecilMenus

func _process(_delta: float) -> void:
	var lib_status = "Missing"
	if Pinecil.pinecil_lib_loaded:
		lib_status = "Existing"
	$GridContainer/VBoxContainer2/PinecilLibStatus.text = lib_status
	
	var con_status = "Disconnected"
	if Pinecil.pinecil_connected:
		con_status = "Connected"
	$GridContainer/VBoxContainer2/PinecilConnected.text = con_status

func _on_main_menu_pressed() -> void:
	Pinecil.change_menu(PinecilMenus.GameJamHome)

func _on_temp_adjust_pressed() -> void:
	Pinecil.change_menu(PinecilMenus.GameJamTemperatureAdjist)

func _on_shake_menu_pressed() -> void:
	Pinecil.change_menu(PinecilMenus.GameJamShake)
