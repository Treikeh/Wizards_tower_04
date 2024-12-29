extends Control


@export_group("Nodes")


func _input(event: InputEvent) -> void:
	# Spawn hud when pressing ESC
	if event.is_action_pressed("ui_cancel"):
		_resume_game()


func _resume_game()-> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.main_scene.change_ui_scene("res://scenes/interface/hud/hud.tscn")


func _on_resume_button_pressed() -> void:
	_resume_game()


func _on_settings_button_pressed() -> void:
	Globals.main_scene.change_ui_scene("res://scenes/interface/settings_menu/settings_menu.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	Globals.main_scene.change_3d_level("res://scenes/levels/main_menu_level/main_menu_level.tscn")
	Globals.main_scene.change_ui_scene("res://scenes/interface/main_menu_ui/main_menu_ui.tscn")


func _on_quit_button_pressed() -> void:
	Globals.main_scene.quit_game()
