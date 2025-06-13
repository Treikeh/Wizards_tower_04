extends Control

func _on_back_button_pressed() -> void:
	queue_free()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
