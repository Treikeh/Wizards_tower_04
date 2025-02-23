extends Node3D
## Scenes that can spawn other scenes. Can be used for spawning enemies


@export_file("*.tscn") var scene_to_spawn: String
@export var spawn_on_ready: bool = false
@export var repeat_spawning: bool = false
@export var spawn_delay: float = 1.5


func _ready() -> void:
	%Mesh.hide()
	%Timer.wait_time = spawn_delay
	%Timer.timeout.connect(spawn_scene)

	if spawn_on_ready:
		spawn_scene()


func spawn_scene() -> void:
	var enemy: Node3D = load(scene_to_spawn).instantiate()
	add_child(enemy)
	if repeat_spawning and %Timer.is_stopped():
		%Timer.start(0.0)
