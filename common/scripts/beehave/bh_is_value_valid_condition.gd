class_name IsValueValidBH
extends ConditionLeaf


## The blackboard key to check
@export var key: StringName


func tick(_actor: Node, blackboard: Blackboard) -> int:
	if is_instance_valid(blackboard.get_value(key)):
		return SUCCESS
	
	return FAILURE
