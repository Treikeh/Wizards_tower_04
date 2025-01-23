extends RigidBody3D


@export var initial_velocity: float = 10.0


func _ready() -> void:
	apply_central_impulse(-global_basis.z * initial_velocity)


func _on_body_entered(_body: Node) -> void:
	#NOTE: Might add a pool of liquid on collision point
	despawn_projectile()


func _on_damage_area_hit_health_area(_health_area: HealthArea3D) -> void:
	despawn_projectile()


func _on_timer_timeout() -> void:
	despawn_projectile()


func despawn_projectile() -> void:
	queue_free()
