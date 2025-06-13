@tool
class_name CallMethodAction
extends ActionLeaf
## Calls a method on the actor and returns SUCCESS. Will return FAILURE if the actor doesn't have the method
## Method can't have any paramaters.


@export var method_name: String


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.has_method(method_name):
		actor.call(method_name)
		return SUCCESS
	
	return FAILURE
