extends BaseMicrogame

var deadzone = 3
var bar_deadzone = 80

var target = 0
var won = false

var last_known_volume = 0
var bar_total_length = 0
var slider_original_pos = 0
var slider_thiccness = 0

func volume_changed(value)-> void:
	print(value)
	print(target)
	print('----------')
	$Slider.position.x = slider_original_pos-bar_total_length/2.0 + bar_deadzone + (((bar_total_length-bar_deadzone*2)/128.0) * value) -slider_thiccness/2.0
		
	if value < target + deadzone and value > target - deadzone:
		$BulbOn.show()
		$BulbOff.hide()
		won = true
	else:
		$BulbOn.hide()
		$BulbOff.show()
		won = false
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BulbOn.hide()
	
	var random_range = []
	for i in range(0,127):
		if i > last_known_volume + deadzone or i < last_known_volume - deadzone:
			random_range.append(i)
	target = random_range.pick_random()
	
	InputManager.volume_change.connect(volume_changed)
	
	bar_total_length = $Bar.texture.get_width()*$Bar.scale.x
	slider_original_pos = $Bar.position.x
	slider_thiccness  = $Slider.texture.get_width()*$Slider.scale.x
	$Slider.position.x = slider_original_pos


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
