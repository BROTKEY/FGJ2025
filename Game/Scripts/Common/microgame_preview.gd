extends Control


@export
var index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var games = GameManager.next_ugames
	print("PreparationScreen #", index, ": games = ", games)
	var game_title = "UNKNOWN GAME"
	var dev_title = "Unknown Device"
	if index < len(games):
		var game = games[index]
		game_title = GameManager.micro_game_names[game]
		var device = GameManager.game_devices[game]
		dev_title = InputManager.DeviceDisplayNames[device]
	$AspectRatioContainer/MarginContainer/VBoxContainer/GameTitle.text = game_title
	$AspectRatioContainer/MarginContainer/VBoxContainer/DeviceName.text = dev_title
