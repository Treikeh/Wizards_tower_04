@tool
extends BTAction


@export var max_range: float = 10.0
@export var target_var: StringName = &"target"


func _generate_name() -> String:
	return "Within \"%d\"m of $%s" % [max_range, target_var]


@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_var)
	if not is_instance_valid(target):
		return FAILURE
	
	var distance_to: float = agent.global_position.distance_to(target.global_position)
	if distance_to < max_range:
		return SUCCESS
	
	return FAILURE
