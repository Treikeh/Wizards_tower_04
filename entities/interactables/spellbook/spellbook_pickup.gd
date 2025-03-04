extends Node3D


signal picked_up


func _on_interact_area_3d_interacted() -> void:
	picked_up.emit()
	
	queue_free()
