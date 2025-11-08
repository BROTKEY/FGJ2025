class_name SplitScreen
extends Node

const _preloaded = preload("res://Scenes/SplitScreen.tscn")

var _scenes = [null, null]

var left_scene: Node:
	get(): return _scenes[0]
	set(value):
		_scenes[0] = value
		_set_sole_child($ChildScenes/TextureRectL/SubViewportL, value)

var right_scene: Node:
	get(): return _scenes[1]
	set(value):
		_scenes[1] = value
		_set_sole_child($ChildScenes/TextureRectR/SubViewportR, value)


static func create_split_screen(left: Node, right: Node) -> SplitScreen:
	var result = _preloaded.instantiate()
	result.left_scene = left
	result.right_scene = right
	return result


func _set_sole_child(parent: Node, child: Node):
	for old_child in parent.get_children():
		old_child.queue_free()
	parent.add_child(child)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _ignore = delta
