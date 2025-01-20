extends Node3D
## Scenes that can spawn other scenes. Can be used for spawning enemies


@export_file("*.tscn") var scene_to_spawn: String
@export var spawn_on_ready: bool = false


func _ready() -> void:
	%Mesh.hide()
	if spawn_on_ready:
		spawn_scene()


func spawn_scene() -> void:
	var enemy: Node3D = load(scene_to_spawn).instantiate()
	add_child(enemy)
