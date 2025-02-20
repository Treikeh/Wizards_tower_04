extends Node3D


@export_group("Nodes")
@export var explosion_cast: ShapeCast3D
@export var camera_shake_source: Area3D


func _on_health_depleted() -> void:
	explosion_cast.trigger()
	camera_shake_source.shake_camera()
