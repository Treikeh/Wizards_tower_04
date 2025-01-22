class_name CopyValueAction
extends ActionLeaf
## Copies the value of old_key to new_key


@export var old_key: StringName = &"key"
@export var new_key: StringName = &"key"


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var value: Variant = blackboard.get_value(old_key)
	blackboard.set_value(new_key, value)
	return SUCCESS
