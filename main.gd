extends Node

@export var world_3d: Node3D
@export var user_interface: CanvasLayer


func quit_game() -> void:
	get_tree().quit()
