@tool
class_name NodeLookAtNodeAction
extends ActionLeaf


@export var node_key: StringName = &"node"
@export var node: Node3D


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var look_at_node: Node3D = blackboard.get_value(node_key)
	if is_instance_valid(look_at_node):
		var position: Vector3 = look_at_node.global_position
		node.look_at(position)
		return SUCCESS
	
	return FAILURE
