extends Node3D


@export var can_spawn_mat: BaseMaterial3D
@export var cannot_spawn_mat: BaseMaterial3D

## If there's enough sapce for the wall to spawn
var enough_space: bool = true


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if %RayCast.is_colliding():
		enough_space = false
		%Mesh.material_override = cannot_spawn_mat
	else:
		enough_space = true
		%Mesh.material_override = can_spawn_mat
