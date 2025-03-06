extends Node3D


signal picked_up


func _on_interact_area_3d_interacted() -> void:
	picked_up.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var menu: Control = UiManager.add_ui_scene("uid://dh8msa1h40vqf")
	menu.tree_exited.connect(_on_menu_tree_exited)


func _on_menu_tree_exited() -> void:
	Globals.construct_spells.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
