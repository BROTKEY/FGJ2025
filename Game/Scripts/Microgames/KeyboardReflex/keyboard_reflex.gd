extends BaseMicrogame

var difficulty: float = 1.0
var won: bool = false

func get_difficulty() -> float:
	return difficulty

func set_difficulty(value: float) -> void:
	difficulty = value

func get_won() -> bool:
	return won

func get_game_name() -> String:
	return 'KeyboardReflex'

func get_input_device() -> InputDevice:
	return InputDevice.MIDI_KEYBOARD
