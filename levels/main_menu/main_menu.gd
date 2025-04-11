extends Node3D


@export_file("*.tscn") var first_level: String
@export_file("*.tscn") var settings_menu_scene: String
@export_file("*.tscn") var credits_scene: String

@export_group(" ")
@export var ui: Control
@export var version_label: Label


func _ready() -> void:
	UiManager.remove_ui_scenes()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	version_label.text = ProjectSettings.get_setting("application/config/version")
	
	var progress: Dictionary = ConfigHandler.load_progress()


func _on_play_button_pressed() -> void:
	LevelManager.change_level(first_level)


func _on_settings_button_pressed() -> void:
	ui.hide()
	var settings_menu: Control = UiManager.add_ui_scene(settings_menu_scene)
	settings_menu.tree_exiting.connect(_on_settings_menu_closed)


func _on_settings_menu_closed() -> void:
	ui.show()


func _on_credits_button_pressed() -> void:
	ui.hide()
	var credits: Control = UiManager.add_ui_scene(credits_scene)
	credits.tree_exiting.connect(_on_credits_menu_closed)


func _on_credits_menu_closed() -> void:
	ui.show()


func _on_quit_button_pressed() -> void:
	Globals.quit_game()


func _on_test_level_button_pressed() -> void:
	LevelManager.change_level("uid://cscm07iintxhd")
