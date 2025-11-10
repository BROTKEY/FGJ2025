extends BaseMicrogame

const NOISE_ZONE = 40

var deadzone = 3
var bar_deadzone = 80

var target = 0
var won = false

var last_known_volume = 0
var bar_total_length = 0
var slider_original_pos = 0
var slider_thiccness = 0

func volume_changed(value)-> void:
	$Slider.position.x = slider_original_pos-bar_total_length/2.0 + bar_deadzone + (((bar_total_length-bar_deadzone*2)/128.0) * value) -slider_thiccness/2.0
	
	var distance = abs(value - target)
	
	if distance < deadzone:
		$BulbOn.show()
		$BulbOff.hide()
		AudioManager.set_white_noise_intensity(0.0)
		won = true
	else:
		$BulbOn.hide()
		$BulbOff.show()
		won = false
		
		if distance < NOISE_ZONE:
			var intensity = float(distance) / float(NOISE_ZONE)
			AudioManager.set_white_noise_intensity(intensity)
		else:
			AudioManager.set_white_noise_intensity(1.0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_known_volume = InputManager.last_known_volume_value
	$BulbOn.hide()
	
	var random_range = []
	for i in range(0,127):
		var d = abs(last_known_volume - i)
		if d > (deadzone + 10):
			random_range.append(i)
	target = random_range.pick_random()
	assert(target != null)
	
	InputManager.volume_change.connect(volume_changed)
	
	bar_total_length = $Bar.texture.get_width()*$Bar.scale.x
	slider_original_pos = $Bar.position.x
	slider_thiccness  = $Slider.texture.get_width()*$Slider.scale.x
	#$Slider.position.x = slider_original_pos
	volume_changed(last_known_volume)


#func get_difficulty() -> float:
	#return difficulty
#
#func set_difficulty(value: float) -> void:
	#difficulty = value

func get_won() -> bool:
	return won

func get_game_name() -> String:
	return 'RadioDial'

func get_input_device() -> InputManager.InputDevice:
	return InputManager.InputDevice.MIDI_KEYBOARD
