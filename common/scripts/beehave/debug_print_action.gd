@tool
class_name DebugPrintAction
extends ActionLeaf


## Text to print to console. Will include the name of the actor before the text ("name": text).
@export var text: String = ""


func tick(actor: Node, _blackboard: Blackboard) -> int:
	print(actor.name + ": " + text)
	return SUCCESS
