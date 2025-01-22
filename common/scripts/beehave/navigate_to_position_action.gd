class_name NavigateToPositionAction
extends ActionLeaf


## Position blackboard key to navigate to
@export var position_key: StringName = &"position"


func tick(actor: Node, blackboard: Blackboard) -> int:
	var position: Vector3 = blackboard.get_value(position_key)
	#TODO: Check if the position is in a nav mesh
	actor.nav_agent.target_position = position
	return SUCCESS
