extends CharacterBody3D

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= 9.8 * delta
	move_and_slide()

func _on_health_health_depleted() -> void:
	queue_free()
