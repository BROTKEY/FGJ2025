extends Node

## Set to true in order to include all games, even if their devices are not connected
const IGNORE_DISCONNECTED_DEVICES = true

const DURATION_MICROGAME = 5.0
const DURATION_TEAMGAME = 10.0
const DURATION_INFOSCREEN = 3.0 # TODO: increase
const DURATION_PREPARATION = 1.0 # TODO: increase


enum State {
	MAIN_MENU,
	INFO_SCREEN,
	PREPARATION,
	MICROGAME,
	TEAM_GAME,
}


enum MicroGame {
	FRY_ME_UP,
	JUMP,
	KEYBOARD_REFLEX,
	RADIO_DIAL,
	SHAKE_ME,
	TEAM_PLATFORMER,
}

enum TeamGame {
	TEAM_PLATFORMER,
}


var game_devices = {
	MicroGame.FRY_ME_UP: InputManager.InputDevice.PINECIL,
	MicroGame.SHAKE_ME: InputManager.InputDevice.PINECIL,
	MicroGame.JUMP: InputManager.InputDevice.WII_BOARD,
	MicroGame.KEYBOARD_REFLEX: InputManager.InputDevice.MIDI_KEYBOARD,
	MicroGame.RADIO_DIAL: InputManager.InputDevice.MIDI_KEYBOARD,
}

var micro_game_scenes = {
	MicroGame.FRY_ME_UP: preload("res://Scenes/Microgames/FryMeUp.tscn"),
	MicroGame.SHAKE_ME: preload("res://Scenes/Microgames/ShakeMe.tscn"),
	MicroGame.JUMP: preload("res://Scenes/Microgames/Jump.tscn"),
	MicroGame.KEYBOARD_REFLEX: preload("res://Scenes/Microgames/KeyboardReflex.tscn"),
	MicroGame.RADIO_DIAL: preload("res://Scenes/Microgames/RadioDial.tscn"),
}

var team_game_devices = {
	TeamGame.TEAM_PLATFORMER: [InputManager.InputDevice.MIDI_KEYBOARD, InputManager.InputDevice.WII_BOARD]
}

var team_game_scenes = {
	TeamGame.TEAM_PLATFORMER: preload("res://Scenes/Microgames/TeamPlatformer.tscn")
}


var current_state = State.MAIN_MENU
var num_games_finished = 0
var lifes = 3

var current_microgames: Array[BaseMicrogame] = []
var current_teamgame = null

var time_in_infoscreen: float = 0.0
var time_in_preparation: float = 0.0
var time_in_microgame: float = 0.0
var time_in_teamgame: float = 0.0

const scene_infoscreen = preload("res://Scenes/InfoScreen.tscn")

func reset_stats() -> void:
	num_games_finished = 0
	lifes = 3


## Start a new game with fresh stats
func start_new_game():
	reset_stats()
	current_microgames.clear()
	current_teamgame = null
	_goto_infoscreen()


## Find available micro games
func scan_for_games() -> Array:
	var found_games = []
	print('Scanning MicroGames...')
	for game_type in game_devices:
		var input_device = game_devices[game_type]
		print(game_type, ': ', input_device)
		if InputManager.is_device_connected(input_device):
			print(" -> Available")
			found_games.append(game_type)
		else:
			print(" -> NOT Available")
			if IGNORE_DISCONNECTED_DEVICES:
				print("   (IGNORE_DISCONNECTED_DEVICES = true, still adding game)")
				found_games.append(game_type)
	print("Found ", len(found_games), " available MicroGames")
	return found_games


## Pick 2 micro games with different devices
func pick_two_games() -> Array:
	var games = scan_for_games()
	assert(len(games) > 0, "No available games found!")
	var game1 = games.pick_random()
	var game1_device = game_devices[game1]
	# Filter out all devices with same device as game1
	var temp = []
	for game in games:
		if game_devices[game] != game1_device:
			temp.append(game)
	games = temp
	assert(len(games) > 0, "Not enough devices available for two games!")
	var game2 = games.pick_random()
	return [game1, game2]


## Pick a random team game (boss game)
func pick_team_game() -> TeamGame:
	print('Scanning TeamGames...')
	var found_games = []
	for game_type in team_game_devices:
		var input_device = team_game_devices[game_type]
		print(game_type, ': ', input_device)
		if InputManager.is_device_connected(input_device):
			print(" -> Available")
			found_games.append(game_type)
		else:
			print(" -> NOT Available")
			if IGNORE_DISCONNECTED_DEVICES:
				print("   (IGNORE_DISCONNECTED_DEVICES = true, still adding game)")
				found_games.append(game_type)
	print("Found ", len(found_games), " available TeamGames")
	assert(len(found_games) > 0, "No available TeamGames found!")
	return found_games.pick_random()


## Reduce lifes and process the remaining lifes
func _reduce_lifes(amount: int = 1):
	lifes -= amount
	print(lifes, " lifes left")
	if lifes <= 0:
		print("Game Over!")
		# TODO: Game over screen?
		_goto_main_menu()
	else:
		_goto_infoscreen()


## Change state to MicroGame
func _goto_microgame():
	print("State -> MicroGame")
	var game_types = pick_two_games()
	print("Picked two games: ", game_types)
	assert(len(game_types) == 2)
	current_microgames.clear()
	for game_type in game_types:
		var game = micro_game_scenes[game_type].instantiate()
		print(" - ", game.get_game_name())
		current_microgames.append(game)
	time_in_microgame = 0.0
	SceneManager.show_split_screen(current_microgames[0], current_microgames[1])
	current_state = State.MICROGAME


func _goto_team_game():
	print("State -> TeamGame")
	time_in_teamgame = 0.0
	current_teamgame = null
	current_state = State.TEAM_GAME
	# TODO: actual transition


func _goto_infoscreen():
	print("State -> InfoScreen")
	time_in_infoscreen = 0.0
	SceneManager.set_current_scene(scene_infoscreen.instantiate())
	current_state = State.INFO_SCREEN
	# TODO: actual transition


func _goto_preparation():
	print("State -> PreparationScreen")
	time_in_preparation = 0.0
	current_state = State.PREPARATION
	# TODO: actual transition


func _goto_main_menu():
	print("State -> MainMenu")
	SceneManager.show_main_menu()
	current_microgames.clear()
	current_teamgame = null
	current_state = State.MAIN_MENU
	# TODO: end screen?


func _process_menu(_delta: float):
	pass


func _process_infoscreen(delta: float):
	time_in_infoscreen += delta
	if time_in_infoscreen >= DURATION_INFOSCREEN:
		_goto_preparation()


func _process_preparation(delta: float):
	time_in_preparation += delta
	if time_in_preparation >= DURATION_PREPARATION:
		_goto_microgame()


func _process_microgame(delta: float):
	time_in_microgame += delta
	if time_in_microgame >= DURATION_MICROGAME:
		print("Time over, ending microgames")
		var won = true
		for game in current_microgames:
			won = won and game.get_won()
		
		if won:
			print("All games won")
		else:
			print("NOT all games won")
			_reduce_lifes()


func _process_teamgame(delta: float):
	time_in_teamgame += delta
	if time_in_teamgame >= DURATION_TEAMGAME:
		print("Time over, ending team game")
		if current_teamgame != null:
			var won = current_teamgame.get_won()
			if won:
				print("Team game won")
			else:
				print("Team game NOT won")
				_reduce_lifes()


func _process(delta: float) -> void:
	match current_state:
		State.MAIN_MENU:
			_process_menu(delta)
		State.INFO_SCREEN:
			_process_infoscreen(delta)
		State.PREPARATION:
			_process_preparation(delta)
		State.MICROGAME:
			_process_microgame(delta)
		State.TEAM_GAME:
			_process_teamgame(delta)
		_:
			# emergency fallback
			_goto_main_menu()
