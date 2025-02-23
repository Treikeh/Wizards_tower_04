extends Enemy


@export_group(" ")
@export var projectile_spawn_transform: Node3D
@export var anim_player: AnimationPlayer

var projectile_scene: PackedScene = preload("uid://x8vosrq0tkhx")


func _attack() -> void:
	#NOTE: If the projectile has gravity it needs to spawn aiming a bit upwards to counter the ->
	#<- gravity, while still being able to hit the target from far away
	var projectile: RigidBody3D = projectile_scene.instantiate()
	projectile_spawn_transform.add_child(projectile)
	projectile.top_level = true


#region Health

func _on_health_depleted() -> void:
	# Disable AI tree and stop movement
	beehave_tree.disable()
	movement_enabled = false
	
	# Play death animation
	anim_player.play("died")

#endregion
