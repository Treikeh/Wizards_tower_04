class_name NodeInRangeCondition
extends ConditionLeaf


@export var node_key: StringName = &"node"
@export var min_range: float = 0.0
@export var max_range: float = 10.0


func tick(actor: Node, blackboard: Blackboard) -> int:
	var node: Node3D = blackboard.get_value(node_key)
	var distance: float = actor.global_position.distance_to(node.global_position)
	if min_range <= distance and distance <= max_range:
		return SUCCESS
	
	return FAILURE
