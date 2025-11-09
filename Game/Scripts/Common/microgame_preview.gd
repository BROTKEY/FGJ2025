extends Control


@export
var index: int = 0


const icon_pinecil = preload("res://Assets/Common/Pinecil.png")
const icon_wiiboard = preload("res://Assets/Common/WiiBoard.png")
const icon_midi_keyboard = preload("res://Assets/Common/MidiKeyboard.png")

const device_icons = {
	InputManager.InputDevice.PINECIL: icon_pinecil,
	InputManager.InputDevice.WII_BOARD: icon_wiiboard,
	InputManager.InputDevice.MIDI_KEYBOARD: icon_midi_keyboard,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var game_title = "UNKNOWN GAME"
	var dev_title = "Unknown Device"
	if  GameManager.num_games_finished > 0 and (GameManager.num_games_finished % GameManager.TEAM_GAME_EVERY_N_GAMES) == 0:
		# do team game
		game_title = "Team Play!"
		var device = InputManager.InputDevice.MIDI_KEYBOARD
		if index != 0:
			device = InputManager.InputDevice.WII_BOARD
		dev_title = InputManager.DeviceDisplayNames[device]
		$AspectRatioContainer/MarginContainer/VBoxContainer/DeviceIcon.texture = device_icons[device]
	else:
		# do micro game
		var games = GameManager.next_ugames
		print("PreparationScreen #", index, ": games = ", games)
		if index < len(games):
			var game = games[index]
			game_title = GameManager.micro_game_names[game]
			var device = GameManager.game_devices[game]
			dev_title = InputManager.DeviceDisplayNames[device]
			if device in device_icons:
				print("Found Icon for device ", dev_title)
				$AspectRatioContainer/MarginContainer/VBoxContainer/DeviceIcon.texture = device_icons[device]
			else:
				print("No Icon found for device ", dev_title)
		else:
			printerr("No ugame defined for player ", index)
	$AspectRatioContainer/MarginContainer/VBoxContainer/GameTitle.text = game_title
	$AspectRatioContainer/MarginContainer/VBoxContainer/DeviceName.text = dev_title
