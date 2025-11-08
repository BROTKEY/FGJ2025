class_name SplitScreen
extends Node

const _preloaded = preload("res://Scenes/SplitScreen.tscn")


static func create_split_screen(left: Node, right: Node) -> SplitScreen:
	var result = _preloaded.instantiate()
	result.set_scenes(left, right)
	return result


func set_scenes(left: Node, right: Node):
	$Viewports/ViewportL.add_child(left)
	$Viewports/ViewportR.add_child(right)
