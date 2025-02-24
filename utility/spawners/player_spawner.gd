extends Node3D


signal player_spawned


@export var id: int = 0
@export var fireball_unlocked: bool = true
@export var rock_wall_unlocked: bool = true
@export var wind_blast_unlocked: bool = true
@export var lightning_ray_unlocked: bool = true

var player_scene: String = "uid://dh8dcfqs8vv8p"


func _ready() -> void:
	$MeshBody.hide()
	
	await get_tree().process_frame
	if id == Globals.checkpoint_id:
		var player_node: Node3D = LevelManager.add_3d_scene(player_scene)
		player_node.global_transform = global_transform
		
		player_spawned.emit()
		
		# Unlock spells
		Globals.fireball_unlocked = fireball_unlocked
		Globals.rock_wall_unlocked = rock_wall_unlocked
		Globals.wind_blast_unlocked = wind_blast_unlocked
		Globals.lightning_ray_unlocked = lightning_ray_unlocked
		#NOTE: This is to show player animations when any spell is unlocked
		if fireball_unlocked or rock_wall_unlocked or wind_blast_unlocked or lightning_ray_unlocked:
			Globals.spell_unlocked.emit(-1)
