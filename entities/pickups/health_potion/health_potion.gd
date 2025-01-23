#@tool
extends Node3D


@export var mesh_rotation_speed: float = 25.0
@export var hover_frequency: float = 1.5
@export var hover_amplitude: float = 0.05
var hover_time: float = 0.0

@export var mesh: Node3D


func _process(delta: float) -> void:
	hover_time += delta
	var vertical: float = sin(hover_time * hover_frequency) * hover_amplitude
	mesh.transform.origin = Vector3(0.0, vertical, 0.0)
	mesh.rotate_object_local(Vector3.UP, deg_to_rad(mesh_rotation_speed * delta))


func _on_damage_area_hit_health_area(health_area: HealthArea3D) -> void:
	var health_node: Health = health_area.health_node
	#print("Max health: %d, current health %d" % [health_node.max_health, health_node.current_health])
	# Only delte node if health was recived
	if health_node.current_health < health_node.max_health:
		queue_free()
