class_name IsDeadBH
extends ConditionLeaf


func tick(_actor: Node, blackboard: Blackboard) -> int:
	if blackboard.get_value(&"is_dead"):
		return SUCCESS
	return FAILURE
