extends Node2D


var last_known_volume = 0
var bar_total_length = 0
var slider_original_pos = 0
var slider_thiccness = 0
var bar_deadzone  = 15
var won = false

func volume_changed(value)-> void:
	$SliderHost.position.x = slider_original_pos + bar_deadzone + (((bar_total_length-bar_deadzone*2)/127)*value) - slider_thiccness/2
	
func jump():
	$Ball.linear_velocity.y = -400
  
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	InputManager.volume_change.connect(volume_changed)
	InputManager.wii_jump.connect(jump)
	
	bar_total_length = $Bar.size.x
	slider_original_pos = $Bar.position.x
	slider_thiccness  = $SliderHost/Slider.size.x
	bar_deadzone += slider_thiccness/2
	$SliderHost.position.x = slider_original_pos + (((bar_total_length-(bar_deadzone * 2))/127) * InputManager.last_known_volume_value) + bar_deadzone - slider_thiccness/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Ball.position.x > get_viewport().size.x:
		won = true
		$Particels.position.y = $Ball.position.y
		$Particels.emitting = true
	pass
