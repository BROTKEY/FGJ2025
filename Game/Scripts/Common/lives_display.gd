extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var lives = GameManager.lifes
	if lives >= 3:
		$Heart3.show()
	else:
		$Heart3.hide()
	if lives >= 2:
		$Heart2.show()
	else:
		$Heart2.hide()
	if lives >= 1:
		$Heart1.show()
	else:
		$Heart1.hide()
