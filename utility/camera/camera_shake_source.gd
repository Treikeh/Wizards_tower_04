class_name CameraShakeSource
extends Area3D
#NOTE: Could probably be a ShapeCast3D


@export var shake_amount: float = 0.1


#TODO: Change func name to "trigger()"
func shake_camera() -> void:
	var overlapping_areas: Array[Area3D] = get_overlapping_areas()
	for area in overlapping_areas:
		if area.has_method("add_camera_shake"):
			area.add_camera_shake(shake_amount)
