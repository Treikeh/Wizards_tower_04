extends Node3D

@export_group("Nodes")
@export var ray_cast_3d: RayCast3D
@export var mesh: MeshInstance3D
## If there's enough sapce for the wall to spawn
var enough_space: bool = true

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if ray_cast_3d.is_colliding():
		enough_space = false
		mesh.scale = Vector3(0.1, 0.1, 0.1)
	else:
		enough_space = true
		mesh.scale = Vector3(1.0, 1.0, 1.0)
