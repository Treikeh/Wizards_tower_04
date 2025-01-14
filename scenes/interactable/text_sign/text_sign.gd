extends Node3D


@export_multiline var text: String

var text_box_scene: String = "res://scenes/interface/text_box/text_box.tscn"


func _on_interact_area_3d_interacted() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Spawn ui text box
	var text_box: UiMenu = load(text_box_scene).instantiate()
	text_box.menu_closed.connect(_on_text_box_menu_closed)
	Globals.main_scene.add_ui_scene(text_box)


func _on_text_box_menu_closed(menu: Control) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	menu.queue_free()
