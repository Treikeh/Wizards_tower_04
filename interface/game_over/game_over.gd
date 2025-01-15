extends Control


@export_file("*.tscn") var main_menu_scene: String


func _on_restart_button_pressed() -> void:
	%RestartButton.text = "WIP"


func _on_main_menu_button_pressed() -> void:
	Globals.main_scene.change_3d_level(main_menu_scene)


func _on_quit_button_pressed() -> void:
	Globals.main_scene.quit_game()
