extends Projectile


func _on_body_entered(_body: Node) -> void:
	despawn_spell()


func _on_damage_area_hit_health_area(_health_area: HealthArea3D) -> void:
	despawn_spell()


func _on_timer_timeout() -> void:
	despawn_spell()


func despawn_spell() -> void:
	queue_free()
