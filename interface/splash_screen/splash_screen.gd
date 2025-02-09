extends Control


@export_file("*.tscn") var main_menu_scene: String


func spawn_main_menu() -> void:
	LevelManager.change_level(main_menu_scene)
