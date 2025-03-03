extends Area3D


@export_file("*.tscn") var level_path: String


func _on_body_entered(_body: Node3D) -> void:
	LevelManager.change_level(level_path)
