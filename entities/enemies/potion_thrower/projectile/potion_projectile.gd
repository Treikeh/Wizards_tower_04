extends Projectile


@export_flags_3d_physics var reflected_collision_mask: int


func _on_reflected() -> void:
	%DamageArea3D.collision_mask = reflected_collision_mask


func _on_body_entered(_body: Node) -> void:
	#NOTE: Might add a pool of liquid on collision point
	despawn_projectile()


func _on_damage_area_hit_health_area(_health_area: HealthArea3D) -> void:
	despawn_projectile()


func _on_timer_timeout() -> void:
	despawn_projectile()


func despawn_projectile() -> void:
	queue_free()
