extends Control


@export_file("*.tscn") var main_menu_scene: String


func spawn_main_menu() -> void:
	Globals.main_scene.change_3d_level(main_menu_scene)
