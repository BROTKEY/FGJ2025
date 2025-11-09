extends BaseMicrogame

var cooked_chicken = preload("res://Assets/Microgames/FryMeUp/Cooked_Chicken_JE3_BE3.png")
var cooking_percentage = 0
var won = false
@export var cooking_time_s = 1
@export var difficulty = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Time.get_ticks_msec() % 50) == 0: # Wait a bit between check to avoid BT Lags
		if (Time.get_ticks_msec() % 250) == 0:
			check_and_set_pinecil_screen()
			
		if InputManager.get_soldering_iron_temprature() >= 180:
			if !won:
				cooking_percentage += delta / cooking_time_s * difficulty
			$Fire.show()
		else:
			$Fire.hide()
			
	if cooking_percentage >= 1 and !won:
		$Chicken.texture = cooked_chicken
		$Particels.emitting = true 
		won = true

func check_and_set_pinecil_screen():
	if InputManager.get_soldering_iron_screen() != InputManager.PinecilMenus.GameJamHome:
		InputManager.set_soldering_iron_screen(InputManager.PinecilMenus.GameJamHome)

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
