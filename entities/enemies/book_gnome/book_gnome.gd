extends Enemy


@export var target_direction: Node3D
@export var animation_tree: AnimationTree


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Idle -> walk animation blend
	animation_tree.set("parameters/BlendTree/walk_blend/blend_amount", move_dir.length())


func _attack() -> void:
	# Play attack animation and sound
	animation_tree.set("parameters/BlendTree/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	#TODO: Audio
	
	# Launch enemy towards target
	recive_knockback(-target_direction.global_basis.z)
	await get_tree().create_timer(0.2).timeout
	$AttackSound.play(0.0)


#region Health

func _on_health_depleted() -> void:
	Globals.enemies_killed += 1
	# Disable AI and movement
	beehave_tree.disable()
	movement_enabled = false
	
	# Play death animation and sound
	animation_tree.set("parameters/conditions/dead", true)
	#TODO: Audio

#endregion
