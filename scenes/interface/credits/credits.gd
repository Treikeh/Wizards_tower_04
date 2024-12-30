extends UiMenu


func _on_back_button_pressed() -> void:
	menu_closed.emit(self)
