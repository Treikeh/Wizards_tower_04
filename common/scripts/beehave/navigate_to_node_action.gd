class_name NavigateToNodeAction
extends ActionLeaf


## Position blackboard key to navigate to
@export var node_key: StringName = &"node"


func tick(actor: Node, blackboard: Blackboard) -> int:
	var node: Node3D = blackboard.get_value(node_key)
	if is_instance_valid(node):
		var position: Vector3 = node.global_position
		#TODO: Check if the position is in a nav mesh
		actor.nav_agent.target_position = position
		return SUCCESS
	
	return FAILURE
