extends Node

# Preloaded scenes
const _main_menu_scene = preload("res://Scenes/MainMenu.tscn")
const _pinecil_debug_scene = preload("res://Scenes/Debug/PinecilDebug.tscn")
const _debug_menu_scene = preload("res://Scenes/Debug/DebugMenu.tscn")


func get_current_scene() -> Node:
	return get_tree().current_screen


## Remove the current scene from the tree and replace it with another scene
func set_current_scene(scene: Node):
	var tree = get_tree()
	var old_scene = tree.current_scene
	tree.root.add_child(scene)
	tree.current_scene = scene
	tree.root.remove_child(old_scene)
	old_scene.queue_free()


func show_main_menu() -> MainMenu:
	var main_menu = _main_menu_scene.instantiate()
	set_current_scene(main_menu)
	return main_menu

func show_debug_menu():
	var debug_menu = _debug_menu_scene.instantiate()
	set_current_scene(debug_menu)
	return debug_menu


func show_split_screen(left_scene: Node, right_scene: Node) -> SplitScreen:
	var split_screen = SplitScreen.create_split_screen(left_scene, right_scene)
	set_current_scene(split_screen)
	return split_screen


func show_split_screen_packed(left_scene: PackedScene, right_scene: PackedScene) -> SplitScreen:
	return show_split_screen(
		left_scene.instantiate(),
		right_scene.instantiate()
	)


func show_split_screen_from_file(left_scene: String, right_scene: String) -> SplitScreen:
	return show_split_screen(
		load(left_scene).instantiate(),
		load(right_scene).instantiate()
	)


## Remove all childs from a node and set another node as its only child
static func _set_only_child(parent: Node, new_child: Node):
	for old_child in parent.get_children():
		old_child.queue_free()
	if new_child != null:
		parent.add_child(new_child)
