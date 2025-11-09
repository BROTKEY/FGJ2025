extends BaseMicrogame

var cooked_chicken = preload("res://Assets/Microgames/FryMeUp/Cooked_Chicken_JE3_BE3.png")
var cooking_percentage = 0
var won = false
@export var cooking_time_s = 1
@export var difficulty = 1.0
@export var pinecil_sample_rate_hz = 100

var next_sample_time = 0
var next_screen_check = 0

func _ready() -> void:
	InputManager.set_soldering_iron_screen(InputManager.PinecilMenus.GameJamTemperatureAdjust)
	var random_start_temp = randi_range(8,12)*10
	InputManager.set_soldering_iron_temperature(random_start_temp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Time.get_ticks_msec() >= next_sample_time: # Wait a bit between check to avoid BT Lags
		if (Time.get_ticks_msec() >= next_screen_check) and false: # Lags too much
			check_and_set_pinecil_screen()
			next_screen_check = Time.get_ticks_msec() + 500 # Check if the Pinecil is on the correct Screen every 500ms
			
		if InputManager.get_soldering_iron_temprature() >= 180:
			if !won:
				cooking_percentage += delta / cooking_time_s * difficulty
			$Fire.show()
		else:
			$Fire.hide()
		
		next_sample_time = Time.get_ticks_msec() + (1000/pinecil_sample_rate_hz)
			
	if cooking_percentage >= 1 and !won:
		$Chicken.texture = cooked_chicken
		$Particels.emitting = true 
		won = true

func check_and_set_pinecil_screen():
	print("Check Screen")
	var current_screen = InputManager.get_soldering_iron_screen()
	if current_screen != InputManager.PinecilMenus.GameJamTemperatureAdjust:
		InputManager.set_soldering_iron_screen(InputManager.PinecilMenus.GameJamTemperatureAdjust)

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

func _on_fire_tree_exiting() -> void:
	InputManager.set_soldering_iron_screen(InputManager.PinecilMenus.GameJamHome)
