extends Node2D

func _ready():
	var uG1 = load("res://Scenes/Microgames/uG1.tscn").instantiate()
	var uG2 = load("res://Scenes/Microgames/uG2.tscn").instantiate()
	
	var uGCanvasLeft = get_node("HFlowContainer/uGameLeft")
	var uGCanvasRight = get_node("HFlowContainer/uGameRight")
	
	uGCanvasLeft.add_child(uG1)
	uGCanvasRight.add_child(uG2)
