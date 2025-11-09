extends Area2D

signal popped

func _on_player_body_entered(_body: Node2D) -> void:
	pass


func _on_player_area_entered(area: Area2D) -> void:
	popped.emit()
