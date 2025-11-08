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
	# TODO: actually load some scenes here
	var left = load("res://scenes/samples/main_menu.tscn").instantiate()
	var right = load("res://scenes/samples/platformer_sample.tscn").instantiate()
	var new_scene = SplitScreen.create_split_screen(left, right)
	self.hide()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene


func _on_exit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	# TODO: enter settings menu
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
