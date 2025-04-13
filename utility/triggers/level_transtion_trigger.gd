extends Area3D


@export_file("*.tscn") var level: String = ""


func _on_body_entered(_body: Node3D) -> void:
	if level == "":
		Globals.rooms_cleared += 1
		Globals.load_next_level()
	else:
		LevelManager.change_level(level)
