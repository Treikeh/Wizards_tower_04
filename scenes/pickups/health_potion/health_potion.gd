extends Node3D


@export var rotation_speed: float = 25.0

@export_group("Nodes")
@export var mesh: Node3D


func _process(delta: float) -> void:
	mesh.rotate_object_local(Vector3.UP, deg_to_rad(rotation_speed * delta))


@warning_ignore("unused_parameter")
func _on_damage_area_3d_collided_with_health_area(health_area: HealthArea3D) -> void:
	queue_free()
