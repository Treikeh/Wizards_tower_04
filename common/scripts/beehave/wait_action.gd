class_name WaitAction
extends ActionLeaf


@export var wait_time: float = 1.0

@onready var cache_key: String = "wait_action_%s" % self.get_instance_id()


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var total_time: float = blackboard.get_value(cache_key, 0.0)
	if total_time < wait_time:
		total_time += get_physics_process_delta_time()
		blackboard.set_value(cache_key, total_time)
		return RUNNING
	else:
		blackboard.set_value(cache_key, 0.0)
		return SUCCESS
