extends MarginContainer


signal menu_closed(menu: Control)


func _on_back_button_pressed() -> void:
	menu_closed.emit(self)
