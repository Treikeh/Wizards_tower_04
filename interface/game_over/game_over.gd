extends Control


@export_file("*.tscn") var main_menu_scene: String


func _on_checkpoint_button_pressed() -> void:
	LevelManager.reload_level()


func _on_restart_button_pressed() -> void:
	Globals.checkpoint_id = 0
	LevelManager.reload_level()


func _on_main_menu_button_pressed() -> void:
	LevelManager.change_level(main_menu_scene)


func _on_quit_button_pressed() -> void:
	Globals.quit_game()
