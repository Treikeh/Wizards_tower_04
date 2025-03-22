extends Control


@export_file("*.tscn") var main_menu_scene: String
@export_file("*.tscn") var level_hub_scene: String


func _ready() -> void:
	%RunDurationLabel.text = "Run duration: " + str(floorf(Globals.run_duration))
	%RoomsClearedLabel.text = "Rooms cleared: " + str(Globals.rooms_cleared)
	%EnemiesKilledLabel.text = "Enemies killed: " + str(Globals.enemies_killed)


func _on_continue_button_pressed() -> void:
	LevelManager.change_level(level_hub_scene)


func _on_main_menu_button_pressed() -> void:
	LevelManager.change_level(main_menu_scene)


func _on_quit_button_pressed() -> void:
	Globals.quit_game()
