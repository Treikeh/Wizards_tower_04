extends Node3D


func _ready() -> void:
	await  get_tree().process_frame
	if $GroundPosition.is_colliding():
		global_position = $GroundPosition.get_collision_point()


func _on_timer_timeout() -> void:
	queue_free()
