extends Node3D


@export_multiline var text: String
var text_popup_scene: String = "uid://qhdu2ae7fbx7"


func _on_interacted() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Spawn ui text box
	var text_popup: Control = UiManager.add_ui_scene(text_popup_scene)
	text_popup.tree_exiting.connect(_on_text_box_menu_closed)
	text_popup.add_text(text)


func _on_text_box_menu_closed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
