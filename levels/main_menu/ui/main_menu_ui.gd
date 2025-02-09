extends Control


@export_file("*.tscn") var first_level_scene: String

@export_file("*.tscn") var settings_menu_scene: String
@export_file("*.tscn") var credits_scene: String


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_play_button_pressed() -> void:
	LevelManager.change_level(first_level_scene)


func _on_settings_button_pressed() -> void:
	hide()
	var settings_menu: Control = UiManager.add_ui_scene(settings_menu_scene)
	settings_menu.tree_exiting.connect(_on_settings_menu_closed)


func _on_settings_menu_closed() -> void:
	show()


func _on_credits_button_pressed() -> void:
	hide()
	var credits: Control = UiManager.add_ui_scene(credits_scene)
	credits.tree_exiting.connect(_on_credits_menu_closed)


func _on_credits_menu_closed() -> void:
	show()


func _on_quit_button_pressed() -> void:
	Globals.quit_game()
