extends Enemy


@export_group(" ")
@export var anim_player: AnimationPlayer

var lightning_srike_scene: String = "uid://xo3qqq1d6oq8"


func attack() -> void:
	var player_node: Node3D = get_tree().get_first_node_in_group("player")
	
	# Spawn lightning strike
	LevelManager.add_3d_scene(lightning_srike_scene, player_node.global_position)



#region Health

func _on_health_depleted() -> void:
	# Disable AI tree and stop movement
	beehave_tree.disable()
	movement_enabled = false
	
	# Play death animation
	anim_player.play("died")

#endregion
