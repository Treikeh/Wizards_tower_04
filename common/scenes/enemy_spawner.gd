extends Node3D


@export_file("*.tscn") var enemy_scene: String
@export var spawn_on_ready: bool = false


func _ready() -> void:
	%Mesh.hide()
	if spawn_on_ready:
		spawn_enemy()


func spawn_enemy() -> void:
	print("spawn enemy")
	var enemy: Enemy = load(enemy_scene).instantiate()
	add_child(enemy)
