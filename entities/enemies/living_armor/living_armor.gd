extends Enemy


func _attack() -> void:
	$living_armor_01_sk/AnimationPlayer.play("attack_001")


#region Health

func _on_health_depleted() -> void:
	Globals.enemies_killed += 1
	# Disable AI tree and stop movement
	beehave_tree.disable()
	nav_agent.target_position = global_position
	
	# Play death animation
	$living_armor_01_sk/AnimationPlayer.play("died_001")

#endregion
