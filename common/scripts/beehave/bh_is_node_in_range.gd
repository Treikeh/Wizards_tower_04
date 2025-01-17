class_name IsNodeInRangeBH
extends ConditionLeaf


@export var key: StringName = &"target"
@export var min_range: float = 0.0
@export var max_range: float = 10.0


func tick(actor: Node, blackboard: Blackboard) -> int:
	var target: Node3D = blackboard.get_value(key)
	var distance: float = actor.global_position.distance_to(target.global_position)
	if distance < max_range and distance > min_range:
		return SUCCESS
	
	return FAILURE
