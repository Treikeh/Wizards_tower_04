@tool
class_name NavigateToNodeAction
extends ActionLeaf


## Position blackboard key to navigate to
@export var node_key: StringName = &"node"


func tick(actor: Node, blackboard: Blackboard) -> int:
	var node: Node3D = blackboard.get_value(node_key)
	if is_instance_valid(node):
		var map: RID = actor.nav_agent.get_navigation_map()
		var position: Vector3 = NavigationServer3D.map_get_closest_point(map, node.global_position)
		actor.nav_agent.target_position = position
		return SUCCESS
	
	return FAILURE
