extends Node3D

func _on_play_button_pressed() -> void:
	var level_path: String = "res://levels/" + %LevelList.text + ".tscn"
	SignalHub.load_level.emit(level_path)

func _on_quit_button_pressed() -> void:
	SignalHub.quit_game.emit()
