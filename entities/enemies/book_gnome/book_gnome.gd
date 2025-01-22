extends Enemy


@export var target_direction: Node3D
@export var animation_tree: AnimationTree


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Idle -> walk animation blend
	animation_tree.set("parameters/walk_blend/blend_amount", move_dir.length())


func _attack() -> void:
	# Play attack animation and sound
	animation_tree.set("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	#TODO: Audio
	
	# Launch enemy towards target
	recive_knockback(-target_direction.global_basis.z)


#region Health

func _on_health_depleted() -> void:
	# Disable AI and movement
	beehave_tree.disable()
	nav_agent.target_position = global_position
	
	# Play death animation and sound
	animation_tree.set("parameters/died/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	#TODO: Audio
	

#endregion
