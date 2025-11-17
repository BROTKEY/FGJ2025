extends Button


@export
var device: InputManager.InputDevice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var icon_texture = InputManager.get_device_icon(device)
	if icon_texture != null:
		icon = icon_texture
	_update_layout()


func _enter_tree() -> void:
	InputManager.device_connected.connect(_on_connection_changed)
	InputManager.device_disconnected.connect(_on_connection_changed)


func _exit_tree() -> void:
	InputManager.device_connected.disconnect(_on_connection_changed)
	InputManager.device_disconnected.disconnect(_on_connection_changed)


func _update_layout() -> void:
	if InputManager.is_device_connected(device):
		self.modulate.a = 1.0
	else:
		self.modulate.a = 0.25


func _on_connection_changed(changed_device: InputManager.InputDevice) -> void:
	if device == changed_device:
		_update_layout()


func _on_pressed() -> void:
	InputManager.connect_device(device)
