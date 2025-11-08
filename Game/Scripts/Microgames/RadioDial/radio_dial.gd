extends Node2D

var deadzone = 3
var bar_deadzone  = 50

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
	$Slider.position.x = slider_original_pos + bar_deadzone + (((bar_total_length-bar_deadzone*2)/127)*value) - slider_thiccness/2
		
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
	
	bar_total_length = $Bar.size.x
	slider_original_pos = $Bar.position.x
	slider_thiccness  = $Slider.size.x
	$Slider.position.x = slider_original_pos + (((bar_total_length-(bar_deadzone * 2))/127) * InputManager.last_known_volume_value) + bar_deadzone - slider_thiccness/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
