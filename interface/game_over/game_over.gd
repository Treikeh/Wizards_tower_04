extends Control


@export_file("*.tscn") var main_menu_scene: String


func _on_checkpoint_button_pressed() -> void:
	%CheckpointButton.text = "WIP! sry"


func _on_restart_button_pressed() -> void:
	Globals.main_scene.change_3d_level(Globals.main_scene.current_3d_level_path)


func _on_main_menu_button_pressed() -> void:
	Globals.main_scene.change_3d_level(main_menu_scene)


func _on_quit_button_pressed() -> void:
	Globals.main_scene.quit_game()
