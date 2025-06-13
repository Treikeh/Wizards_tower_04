extends Node3D


@export var mesh_rotation_speed: float = 25.0
@export var hover_frequency: float = 1.5
@export var hover_amplitude: float = 0.05
var hover_time: float = 0.0


func _process(delta: float) -> void:
	hover_time += delta
	var vertical: float = sin(hover_time * hover_frequency) * hover_amplitude
	transform.origin = Vector3(0.0, vertical, 0.0)
	rotate_object_local(Vector3.UP, deg_to_rad(mesh_rotation_speed * delta))
