extends PlayerState


@export var speed: float = 8.0
@export var accel: float = 10.0

const leave_y_speed = 3.0


func enter() -> void:
	player.gravity_scale = 0.1


func physics_update(delta: float) -> void:
	# Update references from player
	var move_dir: Vector3 = machine.get_value("move_dir")
	var ground_normal: Vector3 = machine.get_value("ground_normal")
	
	# Calculate needed velocity
	var slope_dir: Vector3 = move_dir.slide(ground_normal)
	var target_vel: Vector3 = slope_dir * speed
	var needed_vel: Vector3 = target_vel - player.linear_velocity# - ground_vel)
	player.apply_central_force(needed_vel * accel * player.mass * delta)
	
	# Move to falling state if not in the air
	if not machine.get_value("is_grounded") or player.linear_velocity.y >= leave_y_speed:
		completed.emit()
