extends Control


@export var start_button : Button
@export var settings_button : Button
@export var exit_button : Button


func _enter_tree():
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)


func _exit_tree():
	start_button.pressed.disconnect(_on_start_pressed)
	settings_button.pressed.disconnect(_on_settings_pressed)
	exit_button.pressed.disconnect(_on_exit_pressed)


func _on_start_pressed():
	GameManager.start_new_game()


func _on_exit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	# TODO: enter settings menu
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
