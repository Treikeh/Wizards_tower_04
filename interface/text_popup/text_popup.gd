extends Control


func add_text(text: String) -> void:
	%Label.text = text


func _on_close_button_pressed() -> void:
	queue_free()
