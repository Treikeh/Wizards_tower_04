extends Node3D


@export_file("*.tscn") var main_menu_ui_scene: String


func _ready() -> void:
	Globals.main_scene.change_ui_scene(main_menu_ui_scene)
