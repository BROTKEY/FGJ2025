extends Node


var _main_menu: Node:
	get(): return get_node("/Game/MainMenu")

var _current_scene_node: Node:
	get(): return get_node("/Game/CurrentScene")

func set_active_scene(scene: Node):
	_set_only_child(_current_scene_node, scene)
	get_tree().current_scene = scene

func get_active_scene() -> Node:
	var scene_node: Node = _current_scene_node
	if scene_node.get_child_count() == 0:
		return null
	return scene_node.get_children()[0]

func get_main_menu():
	pass

static func _set_only_child(parent: Node, new_child: Node):
	for old_child in parent.get_children():
		old_child.queue_free()
	parent.add_child(new_child)
