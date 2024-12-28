extends Node3D


@export var _can_spawn_mat: BaseMaterial3D
@export var _cannot_spawn_mat: BaseMaterial3D

@export_group("Nodes")
@export var _ray_cast_3d: RayCast3D
@export var _mesh: MeshInstance3D
## If there's enough sapce for the wall to spawn
var enough_space: bool = true


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if _ray_cast_3d.is_colliding():
		enough_space = false
		_mesh.material_override = _cannot_spawn_mat
	else:
		enough_space = true
		_mesh.material_override = _can_spawn_mat
