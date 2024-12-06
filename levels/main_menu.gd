extends Node3D

func _on_play_button_pressed() -> void:
	LevelManager.load_level("res://levels/test_level.tscn")

func _on_quit_button_pressed() -> void:
	SignalHub.quit_game.emit()
