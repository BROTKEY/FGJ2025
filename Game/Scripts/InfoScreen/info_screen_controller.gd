extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var max_time = GameManager.DURATION_INFOSCREEN
	var time = GameManager.time_in_infoscreen
	var dt = max_time - time
	print(dt)
	var secs_left = int(ceil(dt))
	$AspectRatioContainer/MarginContainer/VBoxContainer/CountDown.text = str(secs_left)
