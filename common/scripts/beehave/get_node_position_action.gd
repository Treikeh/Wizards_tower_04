class_name GetNodePositionAction
extends ActionLeaf


## Blackboard reference to the node to look at
@export var node_key: StringName = &"node"
## Blackboard key to save position of node
@export var save_key: StringName = &"node_position"


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var node: Node3D = blackboard.get_value(node_key)
	if is_instance_valid(Node):
		blackboard.set_value(save_key, node.global_position)
		return SUCCESS
	
	return FAILURE
