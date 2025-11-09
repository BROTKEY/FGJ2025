extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


const pinecil = preload("res://Assets/Common/Pinecil.png")
const pinecil_trans = preload("res://Assets/Common/PinecilTrans.png")

const wiiboard = preload("res://Assets/Common/WiiBoard.png")
const wiiboard_trans = preload("res://Assets/Common/WiiBoardTrans.png")

const midi = preload("res://Assets/Common/MidiKeyboard.png")
const midi_trans = preload("res://Assets/Common/MidiKeyboardTrans.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if InputManager.is_device_connected(InputManager.InputDevice.PINECIL):
		$IconsContainer/Pinecil.texture = pinecil
	else:
		$IconsContainer/Pinecil.texture = pinecil_trans
	if InputManager.is_device_connected(InputManager.InputDevice.MIDI_KEYBOARD):
		$IconsContainer/MidiKeyboard.texture = midi
	else:
		$IconsContainer/MidiKeyboard.texture = midi_trans
	if InputManager.is_device_connected(InputManager.InputDevice.WII_BOARD):
		$IconsContainer/WiiBoard.texture = wiiboard
	else:
		$IconsContainer/WiiBoard.texture = wiiboard_trans
