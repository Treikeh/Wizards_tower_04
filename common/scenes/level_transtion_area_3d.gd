extends Area3D


@export_file("*.tscn") var level_path: String

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		LevelManager.change_level(level_path)
		#Globals.main_scene.change_3d_level(level_path)
