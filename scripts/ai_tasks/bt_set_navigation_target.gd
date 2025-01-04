extends BTAction


@export var target_value: StringName = &"target"


@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_value)
	agent.navigation.target_position = target.global_position
	#agent.move_to(target.global_position)
	return SUCCESS
