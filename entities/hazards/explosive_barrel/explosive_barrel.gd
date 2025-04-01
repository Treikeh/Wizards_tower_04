extends Node3D

@onready var camera_shake_source: CameraShakeSource = $CameraShakeSource
@onready var explosion_cast_3d: ShapeCast3D = $ExplosionCast3D


func _on_health_depleted() -> void:
	explosion_cast_3d.trigger()
	camera_shake_source.shake_camera()
	queue_free()
