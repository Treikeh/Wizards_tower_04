extends Enemy


@export var animation_player: AnimationPlayer


#region Health

func _on_health_depleted() -> void:
	# Disable AI tree and stop movement
	beehave_tree.disable()
	nav_agent.target_position = global_position
	
	# Play death animation
	%AnimationPlayer.play("died")

#endregion
