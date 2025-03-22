extends PlayerState


@export var jump_force: float = 5.0


func enter() -> void:
	if machine.get_value("is_grounded"):
		player.linear_velocity.y = jump_force
	
	completed.emit()
