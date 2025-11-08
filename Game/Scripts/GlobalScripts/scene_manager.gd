extends Node


enum SceneType {
	MAIN_MENU,
	SCENE,
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


func show_scene(scene: Node) -> Node:
	_set_only_child(_current_scene_node, scene)
	get_tree().current_scene = scene
	_main_menu.hide()
	_active_scene_type = SceneType.SCENE
	return scene


func show_split_screen(left_scene: Node, right_scene: Node):
	var split_screen = SplitScreen.create_split_screen(left_scene, right_scene)
	return show_scene(split_screen)


func show_split_screen_packed(left_scene: PackedScene, right_scene: PackedScene):
	return show_split_screen(
		left_scene.instantiate(),
		right_scene.instantiate()
	)


func show_split_screen_from_file(left_scene: String, right_scene: String):
	return show_split_screen(
		load(left_scene).instantiate(),
		load(right_scene).instantiate()
	)


func show_main_menu():
	var menu = _main_menu
	menu.show()
	get_tree().current_scene = menu
	_active_scene_type = SceneType.MAIN_MENU
