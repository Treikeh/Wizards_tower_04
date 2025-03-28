extends Projectile


@export var launch_force: float = 10.0

@export_group(" ")
@export var explosion_cast: ShapeCast3D
@export var anim_player: AnimationPlayer


func _on_force_hit() -> void:
	queue_free()


func _on_launch_area_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		body.set_axis_velocity(Vector3.UP * launch_force)
	elif body is Enemy:
		body.recive_knockback(Vector3.UP, launch_force)


func _on_damage_area_3d_hit_health_area(health_area: HealthArea3D) -> void:
	if health_area == $HealthArea3D:
		return
	$DamageArea3D.queue_free.call_deferred()
	linear_velocity = Vector3.ZERO


func _on_health_depleted() -> void:
	explosion_cast.trigger()
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
