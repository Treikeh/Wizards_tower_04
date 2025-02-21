class_name NavigateToPositionAction
extends ActionLeaf


@export var wait_until_reached: bool = false
## Position blackboard key to navigate to
@export var position_key: StringName = &"position"


func tick(actor: Node, blackboard: Blackboard) -> int:
	var map: RID = actor.nav_agent.get_navigation_map()
	var position: Vector3 = NavigationServer3D.map_get_closest_point(map, blackboard.get_value(position_key))
	actor.nav_agent.target_position = position
	if wait_until_reached:
		if actor.nav_agent.is_navigation_finished():
			return SUCCESS
		return RUNNING
	return SUCCESS
