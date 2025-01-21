extends MarginContainer


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and visible:
		queue_free()


func _on_back_button_pressed() -> void:
	queue_free()
