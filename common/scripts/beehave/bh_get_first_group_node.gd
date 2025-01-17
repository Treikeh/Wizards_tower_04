class_name GetFirstGroupNodeBH
extends ActionLeaf


@export var key: StringName = &"target"
@export var group: String = ""


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var node: Node = get_tree().get_first_node_in_group(group)
	if is_instance_valid(node):
		blackboard.set_value(key, node)
		return SUCCESS
	
	return FAILURE
