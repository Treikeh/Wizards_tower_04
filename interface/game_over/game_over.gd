extends Control


@export_file("*.tscn") var main_menu_scene: String


func _on_continue_button_pressed() -> void:
	Globals.checkpoint_id = 0
	Globals.selected_spells = ["", ""]
	LevelManager.change_level("uid://duxdyc4s7a4ii")


func _on_main_menu_button_pressed() -> void:
	LevelManager.change_level(main_menu_scene)


func _on_quit_button_pressed() -> void:
	Globals.quit_game()
