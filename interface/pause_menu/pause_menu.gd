extends Control


@export_file("*.tscn") var main_menu_scene: String
@export_file("*.tscn") var settings_menu_scene: String


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and visible:
		_resume_game()


func _resume_game()-> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	queue_free()


func _on_resume_button_pressed() -> void:
	_resume_game()


func _on_restart_level_button_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	LevelManager.reload_level()


func _on_settings_button_pressed() -> void:
	hide()
	var settings_menu: Control = UiManager.add_ui_scene(settings_menu_scene)
	settings_menu.tree_exiting.connect(_on_settings_menu_closed)


func _on_settings_menu_closed()-> void:
	show()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	LevelManager.change_level(main_menu_scene)


func _on_quit_button_pressed() -> void:
	Globals.quit_game()
