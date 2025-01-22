class_name GetFirstNodeInGroupAction
extends ActionLeaf


## Group to get the first node of
@export var group: String = ""
## Blackboard key to save node reference to
@export var save_key: StringName = &"node"


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var node: Node = get_tree().get_first_node_in_group(group)
	if is_instance_valid(node):
		blackboard.set_value(save_key, node)
		return SUCCESS
	
	return FAILURE
