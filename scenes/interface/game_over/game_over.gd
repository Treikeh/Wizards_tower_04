extends Control


func _on_restart_button_pressed() -> void:
	%RestartButton.text = "WIP"


func _on_main_menu_button_pressed() -> void:
	Globals.main_scene.change_3d_level("res://scenes/levels/main_menu_level/main_menu_level.tscn")
	Globals.main_scene.change_ui_scene("res://scenes/interface/main_menu_ui/main_menu_ui.tscn")


func _on_quit_button_pressed() -> void:
	Globals.main_scene.quit_game()
