@tool
extends BTAction


@export var group: StringName = &"player"
@export var target_var: StringName = &"target"


func _generate_name() -> String:
	return "Get first node in \"%s\" group -> $%s" % [group, target_var]


@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	var target_node: Node3D = agent.get_tree().get_first_node_in_group(group)
	# Check if node is valid
	if is_instance_valid(target_node):
		blackboard.set_var(target_var, target_node)
		return SUCCESS
	
	return FAILURE
