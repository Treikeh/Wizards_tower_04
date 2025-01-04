extends BTAction


@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	agent.navigation.target_position = Vector3.ZERO
	return SUCCESS
