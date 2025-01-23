class_name NavigateToPositionAction
extends ActionLeaf


## Position blackboard key to navigate to
@export var position_key: StringName = &"position"


func tick(actor: Node, blackboard: Blackboard) -> int:
	var map: RID = actor.nav_agent.get_navigation_map()
	var position: Vector3 = NavigationServer3D.map_get_closest_point(map, blackboard.get_value(position_key))
	#TODO: Check if the position is in a nav mesh
	actor.nav_agent.target_position = position
	return SUCCESS
