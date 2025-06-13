class_name NodeLookAtPositionAction
extends ActionLeaf


@export var position_key: StringName = &"node"
@export var node: Node3D


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var position: Vector3 = blackboard.get_value(position_key)
	node.look_at(position)
	return SUCCESS
