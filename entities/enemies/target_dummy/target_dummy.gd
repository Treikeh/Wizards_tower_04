extends Enemy


func _on_health_depleted() -> void:
	queue_free()
