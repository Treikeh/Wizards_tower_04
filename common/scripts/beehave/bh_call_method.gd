class_name CallMethodBH
extends ActionLeaf


@export var method_name: String


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.call(method_name)
	return SUCCESS
