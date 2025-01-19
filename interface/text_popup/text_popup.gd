extends Control


func add_text(text: String) -> void:
	%RichTextLabel.text = text


func _on_close_button_pressed() -> void:
	queue_free()
