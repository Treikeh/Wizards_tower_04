extends UiMenu


func _on_close_button_pressed() -> void:
	menu_closed.emit(self)
