extends Node3D


@export_file("*.tscn") var enemy_scene: String
@export var spawn_on_ready: bool = true


func _ready() -> void:
	if spawn_on_ready:
		spawn_enemy.call_deferred()


func spawn_enemy() -> void:
	var enemy: Enemy = load(enemy_scene).instantiate()
	enemy.global_transform = global_transform
	Globals.main_scene.world_3d.add_child(enemy)
