extends BTAction


@export var group: StringName = &"player"
@export var target_value: StringName = &"target"


@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	# Get palyer
	if group == "player":
		var player_node: Node3D = agent.get_tree().get_first_node_in_group(group)
		if player_node != null:
			blackboard.set_var(target_value, player_node)
			return SUCCESS
	return FAILURE
