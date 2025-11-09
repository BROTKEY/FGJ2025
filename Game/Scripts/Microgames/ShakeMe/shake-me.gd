extends BaseMicrogame

var last_state = 0
var shakes = 0
var goal_shakes = 10
var won = false
@export var difficulty = 1.0
@export var pinecil_sample_rate_hz = 100

var next_accel_sample = 0

func _ready() -> void:
	InputManager.set_soldering_iron_screen(InputManager.PinecilMenus.GameJamShake)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var shake_state = 0
	if Time.get_ticks_msec() >= next_accel_sample:
		shake_state = InputManager.get_soldering_iron_shake_state()
		next_accel_sample = Time.get_ticks_msec() + (1000/pinecil_sample_rate_hz)

	#shake down
	if shake_state <= -1:
		$Bottle.position = Vector2(564, 424)
		if !won:
			shakes += 1
		last_state = shake_state
	#shake up	
	if shake_state >= 1:
		$Bottle.position = Vector2(564, 224)
		if !won:
			shakes += 1
		last_state = shake_state
			
	if shake_state == 0:
		$Bottle.position = Vector2(564, 324)
		
		
	if shakes >= difficulty*goal_shakes and last_state >=1 and !won:
		$Particels.emitting = true
		won = true
	pass


func get_difficulty() -> float:
	return difficulty

func set_difficulty(value: float) -> void:
	difficulty = value

func get_won() -> bool:
	return won

func get_game_name() -> String:
	return 'ShakeMe'

func get_input_device() -> InputManager.InputDevice:
	return InputManager.InputDevice.PINECIL
	
func _on_tree_exiting() -> void:
	InputManager.set_soldering_iron_screen(InputManager.PinecilMenus.GameJamHome)
