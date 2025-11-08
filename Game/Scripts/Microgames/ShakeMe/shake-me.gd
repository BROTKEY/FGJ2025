extends Node

var last_state = 0
var shakes = 0
var goal_shakes = 10
var won = false
@export var difficulty = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var shake_state = InputManager.get_soldering_iron_shake_state()
	print(shakes)
	
	#shake down
	if shake_state <= -1:
		$Bottle.position = Vector2(564, 424)
		if last_state != shake_state and !won:
			shakes += 1
		last_state = shake_state
	#shake up	
	if shake_state >= 1:
		$Bottle.position = Vector2(564, 224)
		if last_state != shake_state and !won:
			shakes += 1
		last_state = shake_state
			
	if shake_state == 0:
		$Bottle.position = Vector2(564, 324)
		
		
	if shakes >= difficulty*goal_shakes and last_state >=1 and !won:
		$Particels.emitting = true
		won = true
	pass
