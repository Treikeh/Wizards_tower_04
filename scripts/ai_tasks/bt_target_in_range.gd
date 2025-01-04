extends BTAction


@export var target_value: StringName = &"target"
@export var max_range: float = 10.0


@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_value)
	var distance_to: float = agent.global_position.distance_to(target.global_position)
	if distance_to < max_range:
		return SUCCESS
	return FAILURE
