extends RigidBody3D


@export var initial_velocity: float = 20.0


func _ready() -> void:
	# Apply initial_velocity
	apply_central_impulse(-global_basis.z * initial_velocity)


func _on_body_entered(_body: Node) -> void:
	despawn_spell()


func _on_damage_area_hit_health_area(_health_area: HealthArea3D) -> void:
	despawn_spell()


func _on_timer_timeout() -> void:
	despawn_spell()


func despawn_spell() -> void:
	queue_free()
