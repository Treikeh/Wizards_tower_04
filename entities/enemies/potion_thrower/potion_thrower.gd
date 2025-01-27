extends Enemy


@export var animation_player: AnimationPlayer
@export var target_direction: Node3D

var projectile_scene: PackedScene = preload("res://entities/enemies/potion_thrower/projectile/potion_projectile.tscn")


func _attack() -> void:
	var projectile: RigidBody3D = projectile_scene.instantiate()
	target_direction.add_child(projectile)
	projectile.top_level = true


#region Health

func _on_health_depleted() -> void:
	# Disable AI tree and stop movement
	beehave_tree.disable()
	movement_enabled = false
	
	# Play death animation
	%AnimationPlayer.play("died")

#endregion
