extends BaseMicrogame

var cooked_chicken = preload("res://Assets/Microgames/FryMeUp/Cooked_Chicken_JE3_BE3.png")
var cooking_percentage = 0
var won = false
@export var cooking_time_s = 1
@export var difficulty = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:     
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

func get_difficulty() -> float:
	return difficulty

func set_difficulty(value: float) -> void:
	difficulty = value

func get_won() -> bool:
	return won
