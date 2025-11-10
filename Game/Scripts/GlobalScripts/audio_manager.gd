extends Node

@onready var audio_player_menu = $AudioPlayerMenu
@onready var audio_player_game_base = $AudioPlayerGameBase
@onready var audio_player_game_left = $AudioPlayerGameLeft
@onready var audio_player_game_right = $AudioPlayerGameRight
@onready var audio_player_white_noise = $AudioPlayerWhiteNoise

var music_game_base: Resource = preload("uid://vjvld7qv7vn1")
var music_game_fry_me_up: Resource = preload("uid://77kdkjhmbocw")
var music_game_jump: Resource = preload("uid://booiouw0b5xdu")
var music_game_keyboard_reflex: Resource = preload("uid://v5hd8s7afyir")
var music_game_radio_dial: Resource = preload("uid://c0y8p48yrthkr")
var music_game_shake_me: Resource = preload("uid://cfc81505ijidp")
var music_game_boss: Resource = preload("uid://b2gr377vycj7b")
var music_game_balloon: Resource = preload("uid://c8y5d2h22nh3t")

var music_transition_base: Resource = preload("uid://ie4vdvs8a5mw")
var music_transition_fry_me_up: Resource = preload("uid://epafrvdupsjc")
var music_transition_jump: Resource = preload("uid://tybtxr35u4ax")
var music_transition_keyboard_reflex: Resource = preload("uid://dq7jlaw28wu6x")
var music_transition_radio_dial: Resource = preload("uid://cx7koyhccur8x")
var music_transition_shake_me: Resource = preload("uid://bpfdalei8lr6m")
var music_transition_balloon: Resource = preload("uid://ba5yfh4opr062")

var audio_microgames_games: Dictionary[String, Resource] = {
	"FryMeUp": music_game_fry_me_up,
	"Jump": music_game_jump,
	"KeyboardReflex": music_game_keyboard_reflex,
	"RadioDial": music_game_radio_dial,
	"ShakeMe": music_game_shake_me,
	"PopTheBalloon": music_game_balloon,
	#"TeamPlatformer": music_game_team_platformer
}

var audio_microgames_transitions: Dictionary[String, Resource] = {
	"BASE": music_transition_base,
	"FryMeUp": music_transition_fry_me_up,
	"Jump": music_transition_jump,
	"KeyboardReflex": music_transition_keyboard_reflex,
	"RadioDial": music_transition_radio_dial,
	"ShakeMe": music_transition_shake_me,
	"PopTheBalloon": music_transition_balloon,
	#"TeamPlatformer": music_transition_team_platformer
}

func stop_music() -> void:
	print("Stopping all music")
	audio_player_menu.stop()
	audio_player_game_base.stop()
	audio_player_game_left.stop()
	audio_player_game_right.stop()
	audio_player_white_noise.stop()

func play_menu() -> void:
	print("Starting menu music")
	stop_music()
	audio_player_menu.play(0)
	
func play_game(game_name_left: String, game_name_right: String) -> void:
	print("Starting game music with left: " + game_name_left + ", right: " + game_name_right)
	stop_music()
	audio_player_game_base.stream = music_game_base
	audio_player_game_left.stream = audio_microgames_games.get(game_name_left, null)
	audio_player_game_right.stream = audio_microgames_games.get(game_name_right, null)
	#
	if (game_name_left == "RadioDial" or game_name_right == "RadioDial"):
		##enable_white_noise_level(true)
		audio_player_white_noise.play()
	else:
		audio_player_white_noise.stop()
		##enable_white_noise_level(false)
	
	audio_player_game_base.play()
	audio_player_game_left.play()
	audio_player_game_right.play()

func play_transition(game_name_left: String, game_name_right: String) -> void:
	print("Starting transition music with left: " + game_name_left + ", right: " + game_name_right)
	stop_music()
	audio_player_game_base.stream = music_transition_base
	audio_player_game_left.stream = audio_microgames_transitions.get(game_name_left, null)
	audio_player_game_right.stream = audio_microgames_transitions.get(game_name_right, null)
	audio_player_game_base.play()
	audio_player_game_left.play()
	audio_player_game_right.play()

func play_game_boss() -> void:
	print("Starting boss music")
	stop_music()
	audio_player_game_base.stream = music_game_boss
	audio_player_game_base.play()
	
func play_transition_base() -> void:
	print("Starting transition music")
	stop_music()
	audio_player_game_base.stream = music_transition_base
	audio_player_game_base.play()

func enable_white_noise_level(active: bool) -> void:
	#var bus_white_noise = AudioServer.get_bus_index("White Noise")
	#var bus_music = AudioServer.get_bus_index("Music")
	#print(AudioServer.get_bus_volume_db(bus_music))
	
	#var max_db = 10
	
	if (active):
		pass
		#AudioServer.set_bus_volume_db(bus_music, max_db)
	else:
		#AudioServer.set_bus_volume_db(bus_music, 2)
		audio_player_white_noise.stop();
		

func set_white_noise_intensity(value: float) -> void:
	value *= 4.0 # Barely hearable else
	audio_player_white_noise.volume_linear = value
