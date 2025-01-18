extends Node3D


@export_file("*.tscn") var text_popup_scene: String
@export_multiline var text: String


func _on_interact_area_3d_interacted() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Spawn ui text box
	var text_popup: Control = Globals.main_scene.add_ui_scene(text_popup_scene)
	text_popup.tree_exiting.connect(_on_text_box_menu_closed)
	text_popup.text = text


func _on_text_box_menu_closed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
