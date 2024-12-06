extends Node

@export var world_3d: Node3D

func _ready() -> void:
	SignalHub.quit_game.connect(on_quit_game)
	LevelManager.level_root = world_3d

func on_quit_game() -> void:
	get_tree().quit()
