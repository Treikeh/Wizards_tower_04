extends Control


@export_group("Nodes")


func _on_play_button_pressed() -> void:
	Globals.main_scene.change_3d_level("res://scenes/levels/test_level.tscn")
	Globals.main_scene.change_ui_scene("res://scenes/interface/hud/hud.tscn")


func _on_settings_button_pressed() -> void:
	Globals.main_scene.change_ui_scene("res://scenes/interface/settings_menu/settings_menu.tscn")


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	Globals.main_scene.quit_game()
