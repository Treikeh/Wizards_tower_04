@tool
extends EditorScript

func _run() -> void:
	var vec_1: Vector3 = Vector3(0.0, 1.0, 0.0).normalized()
	var vec_2: Vector3 = Vector3(0.0, 1.0, 0.0).normalized()
	
	var dot: float = (vec_1.dot(vec_2))
	var angle: float = rad_to_deg(vec_1.angle_to(vec_2))
	print("Angle: " + str(angle) + " Dot: " + str(dot))
