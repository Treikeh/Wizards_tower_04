extends UiMenu


var text: String


func _ready() -> void:
	%RichTextLabel.text = text


func _on_close_button_pressed() -> void:
	menu_closed.emit(self)
