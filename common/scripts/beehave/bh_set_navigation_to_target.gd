class_name SetNavigationToTargetBH
extends ActionLeaf


@export var key: StringName = &"target"
#@export var wait_until_target_reached: bool = false


func tick(actor: Node, blackboard: Blackboard) -> int:
	var target: Node3D = blackboard.get_value(key)
	if is_instance_valid(target):
		actor.nav_agent.target_position = target.global_position
		return SUCCESS
	
	return FAILURE
