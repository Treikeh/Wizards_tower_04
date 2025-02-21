class_name GetRandomPositionInRange
extends ActionLeaf


@export var min_range: float = 0.0
@export var max_range: float = 10.0
@export var save_key: StringName = &"position"


func tick(actor: Node, blackboard: Blackboard) -> int:
	var x: float = randf_range(-max_range, max_range)
	var y: float = randf_range(-max_range, max_range)
	var z: float = randf_range(-max_range, max_range)
	var position: Vector3 = actor.global_position + Vector3(x, y, z)
	
	blackboard.set_value(save_key, position)
	return SUCCESS
