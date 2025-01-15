extends Control


@export_file("*.tscn") var first_level_scene: String

@export_file("*.tscn") var settings_menu_scene: String
@export_file("*.tscn") var credits_scene: String


func _on_play_button_pressed() -> void:
	Globals.main_scene.change_3d_level(first_level_scene)


func _on_settings_button_pressed() -> void:
	hide()
	var settings_menu: Control = load(settings_menu_scene).instantiate()
	settings_menu.menu_closed.connect(_on_settings_menu_closed)
	Globals.main_scene.add_ui_scene(settings_menu)


func _on_settings_menu_closed(menu: Control) -> void:
	show()
	menu.queue_free()


func _on_credits_button_pressed() -> void:
	hide()
	var credits: UiMenu = load(credits_scene).instantiate()
	credits.menu_closed.connect(_on_credits_menu_closed)
	Globals.main_scene.add_ui_scene(credits)


func _on_credits_menu_closed(menu: Control) -> void:
	show()
	menu.queue_free()


func _on_quit_button_pressed() -> void:
	Globals.main_scene.quit_game()
