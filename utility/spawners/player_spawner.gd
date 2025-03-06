extends Node3D


signal player_spawned


@export var reset_player: bool = false
var player_scene: String = "uid://dh8dcfqs8vv8p"


func _ready() -> void:
	$MeshBody.hide()
	if reset_player:
		Globals.reset_player()
	
	await get_tree().process_frame
	var player_node: Node3D = LevelManager.add_3d_scene(player_scene)
	player_node.global_transform = global_transform
	player_spawned.emit()
