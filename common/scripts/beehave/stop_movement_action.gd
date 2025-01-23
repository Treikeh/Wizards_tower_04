class_name StopMovementAction
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.nav_agent.target_position = actor.global_position
	return SUCCESS
