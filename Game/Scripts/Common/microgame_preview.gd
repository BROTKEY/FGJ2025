extends Control


@export
var index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var games = GameManager.current_microgames
	if index < len(games):
		var game = games[index]
		$AspectRatioContainer/MarginContainer/VBoxContainer/GameTitle.text = game.get_game_name()
		$AspectRatioContainer/MarginContainer/VBoxContainer/DeviceName.text = InputManager.DeviceDisplayNames[game.get_input_device()]
