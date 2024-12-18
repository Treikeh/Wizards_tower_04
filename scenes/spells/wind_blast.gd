extends Node3D

var force: float
var lifetime: float = 0.2

@export_group("Nodes")
@export var collision_shape: ShapeCast3D

func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(despawn_spell)
	collision_shape.force_shapecast_update()
	for collision in collision_shape.get_collision_count():
		var collider: Object = collision_shape.get_collider(collision)
		if collider is RigidBody3D:
			collider.apply_central_impulse(-global_basis.z * force)

func despawn_spell() -> void:
	queue_free()
