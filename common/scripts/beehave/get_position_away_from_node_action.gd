@tool
class_name GetPositionAwayFromNodeAction
extends ActionLeaf


## Node to move away from
@export var node_key: StringName = &"node"
## Key to save position to
@export var save_key: StringName = &"positon"
## Distance away from node to move to
@export var distance: float = 5.0


func tick(actor: Node, blackboard: Blackboard) -> int:
	var node: Node3D = blackboard.get_value(node_key)
	if is_instance_valid(node):
		# I was so sure this wasn't going to work, but it does and i have no idea why
		var node_position: Vector3 = node.global_position
		var direction_to: Vector3 = node_position.direction_to(actor.global_position)
		var position: Vector3 = node_position + (direction_to * distance)
		blackboard.set_value(save_key, position)
		return SUCCESS
		
	return FAILURE
