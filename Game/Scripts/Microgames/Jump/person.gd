extends RigidBody2D

signal hit

func _on_hurdle_body_entered(body: Node2D) -> void:
	if body.name == 'Person':
		hit.emit()
