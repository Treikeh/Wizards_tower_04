@tool
extends BTAction


func _generate_name() -> String:
	return "Stop movement"


@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	agent.navigation.target_position = agent.global_position
	return SUCCESS
