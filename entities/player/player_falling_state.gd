extends PlayerState


@export var speed: float = 8.0
@export var accel: float = 175.0


func enter() -> void:
	player.gravity_scale = 1.0


func physics_update(delta: float) -> void:
	var move_dir: Vector3 = machine.get_value("move_dir")
	
	var target_vel: Vector3 = move_dir * speed
	var gravity_vector: Vector3 = player.linear_velocity.dot(Vector3.DOWN) * Vector3.DOWN
	var needed_vel: Vector3 = target_vel - (player.linear_velocity - gravity_vector)
	player.apply_central_force(needed_vel * accel * player.mass * delta)
	
	# Transition to walking state when grounded
	if machine.get_value("is_grounded"):
		completed.emit()
