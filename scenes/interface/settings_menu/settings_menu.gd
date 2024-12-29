extends MarginContainer


func _on_back_button_pressed() -> void:
	if get_tree().paused:
		Globals.main_scene.change_ui_scene("res://scenes/interface/pause_menu/pause_menu.tscn")
	else:
		Globals.main_scene.change_ui_scene("res://scenes/interface/main_menu_ui/main_menu_ui.tscn")
