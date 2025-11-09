extends BaseMicrogame

var hurdle_speed_px_p_s = 400
var player_max_jump_heigth_px =  300
@export var difficulty = 1.0
var start_delay_min = 1.0
var start_delay_max = 3.0
var delay
var time = 0
var won = true

func on_hit():
	$Particels.emitting=true
	won = false

func jump():
	$Person.linear_velocity.y = -1000
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delay = randf_range(start_delay_min/difficulty, start_delay_max)
	$Person.hit.connect(on_hit)
	InputManager.wii_jump.connect(jump)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > delay:
		$Hurdle.position -= Vector2(5*difficulty,0)

func get_difficulty() -> float:
	return difficulty

func set_difficulty(value: float) -> void:
	difficulty = value

func get_won() -> bool:
	return won

func get_game_name() -> String:
	return 'Jump'

func get_input_device() -> InputManager.InputDevice:
	return InputManager.InputDevice.WII_BOARD
