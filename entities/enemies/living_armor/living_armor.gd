extends Enemy


@export var animation_player: AnimationPlayer


func _attack() -> void:
	$Mesh/living_armor_01_sk/AnimationPlayer.play("attack_001")


#region Health

func _on_health_depleted() -> void:
	# Disable AI tree and stop movement
	beehave_tree.disable()
	nav_agent.target_position = global_position
	
	# Play death animation
	$Mesh/living_armor_01_sk/AnimationPlayer.play("died_001")

#endregion
