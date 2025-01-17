extends Control


@export_file("*.tscn") var main_menu_scene: String


func spawn_main_menu() -> void:
	var main_menu: Node3D  = load(main_menu_scene).instantiate()
	Globals.main_scene.add_3d_scene(main_menu)
