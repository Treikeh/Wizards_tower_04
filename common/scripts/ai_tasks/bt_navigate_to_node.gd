@tool
extends BTAction


@export var target_var: StringName = &"target"


func _generate_name() -> String:
	return "Set navigation position to $%s global_position" % [target_var]


@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_var)
	agent.navigation.target_position = target.global_position
	#agent.move_to(target.global_position)
	return SUCCESS
