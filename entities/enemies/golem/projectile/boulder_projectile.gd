extends Projectile


func _on_body_entered(_body: Node) -> void:
	queue_free()
