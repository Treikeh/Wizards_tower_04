extends Node

@export var world_3d: Node3D

#svar up_vector: Vector3 = Vector3.UP

func _ready() -> void:
	SignalHub.quit_game.connect(on_quit_game)
	LevelManager.level_root = world_3d
	#var forward_vector: Vector3 = up_vector.rotated(Vector3.LEFT, deg_to_rad(90.0))
	#print("Up: " + str(up_vector) + " Forward: " + str(forward_vector))

func on_quit_game() -> void:
	get_tree().quit()
