extends Projectile

@export_group(" ")
@export var explosion_cast: ShapeCast3D


func _on_reflected() -> void:
	pass # Replace with function body.


func _on_body_entered(_body: Node) -> void:
	queue_free()


func _on_damage_area_3d_hit_health_area(_health_area: HealthArea3D) -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()


func _on_health_health_depleted() -> void:
	explosion_cast.trigger()
	queue_free()
