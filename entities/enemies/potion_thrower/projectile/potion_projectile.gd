extends RigidBody3D


@export var initial_velocity: float = 10.0


func _ready() -> void:
	apply_central_impulse(-global_basis.z * initial_velocity)


func _on_timer_timeout() -> void:
	queue_free()
