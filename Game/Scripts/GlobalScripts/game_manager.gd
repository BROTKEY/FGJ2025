extends Node


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

#var available_games: Array[PackedScene] = []
var current_microgames: Array[BaseMicrogame] = []
var current_teamgame = null

var time_in_infoscreen: float = 0.0
var time_in_preparation: float = 0.0
var time_in_microgame: float = 0.0
var time_in_teamgame: float = 0.0


const DURATION_MICROGAME = 5.0
const DURATION_TEAMGAME = 10.0
const DURATION_INFOSCREEN = 5.0
const DURATION_PREPARATION = 3.0


func reset_stats() -> void:
	num_games_finished = 0
	lifes = 3


func back_to_menu():
	SceneManager.show_main_menu()
	current_microgames.clear()
	current_teamgame = null
	current_state = State.MAIN_MENU


#func scan_for_games() -> Array[PackedScene]:
	#available_games.clear()
	#print('Scanning MicroGames...')
	#for game_type in game_devices:
		#var input_device = game_devices[game_type]
		#print(game_type, ': ', input_device)
		#if InputManager.is_device_connected(input_device):
			#print(" -> Available")
			#available_games.append(micro_game_scenes[game_type])
		#else:
			#print(" -> NOT Available")
	#print("Found ", len(available_games), " available MicroGames")
	#return available_games
	
func scan_for_games() -> Array[MicroGame]:
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
	print("Found ", len(found_games), " available MicroGames")
	return found_games




func pick_two_games() -> Array[MicroGame]:
	var games = scan_for_games()
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
	print("Found ", len(found_games), " available TeamGames")
	assert(len(found_games) > 0, "No available TeamGames found!")
	return found_games.pick_random()


## Start a new game with fresh stats
func start_game():
	# Get available games
	pass
	


func _process_menu(_delta: float):
	pass


func _process_infoscreen(delta: float):
	time_in_infoscreen += delta


func _process_preparation(delta: float):
	time_in_preparation += delta


func _process_microgame(delta: float):
	time_in_microgame += delta
	if time_in_microgame >= DURATION_MICROGAME:
		print("Time over, ending microgames")
		on_microgame_end()


func _process_teamgame(delta: float):
	time_in_teamgame += delta


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


func on_microgame_end():
	var won = true
	for game in current_microgames:
		won = won and game.get_won()
	
	if won:
		print("All games won")
	else:
		print("NOT all games won")
		lifes -= 1
		print(lifes, " lifes left")
	
	if lifes <= 0:
		print("Game Over!")
		# TODO: Game over screen?
		back_to_menu()
