extends Projectile


@export_group(" ")
@export var explosion: ShapeCast3D
@export var damage_area: DamageArea3D
@export var mesh: MeshInstance3D

var explode: bool = false


func _on_body_entered(_body: Node) -> void:
	despawn_spell()


func _on_damage_area_hit_health_area(_health_area: HealthArea3D) -> void:
	despawn_spell()


func _on_timer_timeout() -> void:
	despawn_spell()


func despawn_spell() -> void:
	if explode:
		explosion.trigger()
	
	queue_free()


func _on_reflected() -> void:
	explode = true
	initial_velocity *= 1.5
	mesh.scale = Vector3(3.0, 3.0, 3.0)
	# Cheap way of "disabling" the damage area while still having it register hits
	damage_area.apply_over_time = true
