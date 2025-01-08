@tool
extends BTAction


@export var position_var: StringName = &"position"


func _generate_name() -> String:
	return "Set navigation position to \"%s\"" % [position_var]


@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	agent.navigation.target_position = blackboard.get_var(position_var)
	return SUCCESS
