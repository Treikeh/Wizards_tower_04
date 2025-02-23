extends Area3D


@export var new_checkpoint_id: int = 0


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Globals.checkpoint_id = new_checkpoint_id
		Globals.notification_message_sent.emit("Checkpoint saved")
		queue_free()
