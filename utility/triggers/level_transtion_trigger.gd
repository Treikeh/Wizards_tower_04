extends Area3D


@export_file("*.tscn") var level_path: String


func _on_body_entered(_body: Node3D) -> void:
	Globals.rooms_cleared += 1
	Globals.load_random_level()
