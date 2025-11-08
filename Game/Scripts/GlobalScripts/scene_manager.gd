extends Node


enum SceneType {
	MAIN_MENU,
	MICRO_GAME,
}


var _active_scene_type: SceneType = SceneType.MAIN_MENU

var _main_menu: Control:
	get(): return get_node("/root/Game/MainMenu/MainMenu")

var _current_scene_node: Node:
	get(): return get_node("/root/Game/CurrentScene")


## Remove all childs from a node and set another node as its only child
static func _set_only_child(parent: Node, new_child: Node):
	for old_child in parent.get_children():
		old_child.queue_free()
	if new_child != null:
		parent.add_child(new_child)


func show_microgame(ugame: Node):
	_set_only_child(_current_scene_node, ugame)
	get_tree().current_scene = ugame
	_main_menu.hide()
	_active_scene_type = SceneType.MICRO_GAME


func show_main_menu():
	var menu = _main_menu
	menu.show()
	get_tree().current_scene = menu
	_active_scene_type = SceneType.MAIN_MENU
