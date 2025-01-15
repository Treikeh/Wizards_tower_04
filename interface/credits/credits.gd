extends UiMenu


func _on_back_button_pressed() -> void:
	menu_closed.emit(self)


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
