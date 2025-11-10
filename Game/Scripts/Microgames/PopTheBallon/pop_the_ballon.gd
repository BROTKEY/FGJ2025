extends BaseMicrogame

var won = false
var difficulty = 1
 
var org_play_pos = Vector2(0,0)

func ballon_poped() -> void:
	if !won:
		$Ballon/Particels.emitting=true
		$Ballon/Ballon2.hide()
	won=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Ballon.rotation = randf_range(0,3.14)
	org_play_pos = $Player.position
	$Ballon.popped.connect(ballon_poped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var posmod = InputManager.get_wii_center_of_mass()*2
	$Player.position = Vector2(org_play_pos.x + posmod.x, org_play_pos.y + posmod.y)

func get_difficulty() -> float:
	return difficulty

func set_difficulty(value: float) -> void:
	difficulty = value

func get_won() -> bool:
	return won

func get_game_name() -> String:
	return 'PopTheBallon'

func get_input_device() -> InputManager.InputDevice:
	return InputManager.InputDevice.WII_BOARD
