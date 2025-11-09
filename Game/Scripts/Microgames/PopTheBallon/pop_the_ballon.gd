extends BaseMicrogame

var won = false
var difficulty = 1
 
var org_play_pos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	org_play_pos = $Player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var posmod = InputManager.get_wii_center_of_mass()
	$Player.position = Vector2(org_play_pos.x + posmod.x, org_play_pos.y + posmod.y)

func get_difficulty() -> float:
	return difficulty

func set_difficulty(value: float) -> void:
	difficulty = value

func get_won() -> bool:
	return won

func get_game_name() -> String:
	return 'FryMeUp'

func get_input_device() -> InputManager.InputDevice:
	return InputManager.InputDevice.PINECIL
