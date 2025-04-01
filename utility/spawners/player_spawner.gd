extends Node3D


@export var on_player_spawned: Dictionary[Node, StringName]
@export var reset_player: bool = false

var player_scene: String = "uid://dh8dcfqs8vv8p"
var hud_scene: String = "uid://bsrvl85f7jxdv"


func _ready() -> void:
	$MeshBody.hide()
	if reset_player:
		Globals.reset_player()
	
	# Spawn hud
	UiManager.change_ui_scene(hud_scene)
	
	await get_tree().process_frame
	var player_node: Node3D = LevelManager.add_3d_scene(player_scene)
	player_node.global_transform = global_transform
	for node: Node in on_player_spawned:
		node.call(on_player_spawned[node])
