extends BaseMicrogame

var cooked_chicken = preload("res://Assets/Microgames/FryMeUp/chicken.png")
var cooking_percentage = 0
var won = false
@export var cooking_time_s = 0.1
@export var difficulty = 1.0
@export var pinecil_sample_rate_hz = 100

var next_sample_time = 0
var next_screen_check = 0

@onready
var FireSprite = $Background/SpriteAnchor/FireSprite
@onready
var ChickenSprite = $Background/SpriteAnchor/ChickenSprite
@onready
var ChickenParticles = $Background/SpriteAnchor/ChickenSprite/Particles

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
		
		var fire_target_animation = "fire_not_burning"
		if InputManager.get_soldering_iron_temprature() >= 180:
			if !won:
				cooking_percentage += delta / cooking_time_s * difficulty
			fire_target_animation = "fire_burning"
		
		if FireSprite.animation != fire_target_animation:
			FireSprite.play(fire_target_animation)
		
		next_sample_time = Time.get_ticks_msec() + (1000/pinecil_sample_rate_hz)
			
	if cooking_percentage >= 1 and !won:
		ChickenSprite.texture = cooked_chicken
		ChickenParticles.emitting = true 
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

func _on_tree_exiting() -> void:
	InputManager.set_soldering_iron_screen(InputManager.PinecilMenus.GameJamHome)
