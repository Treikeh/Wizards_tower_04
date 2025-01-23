extends Enemy


@export var animation_player: AnimationPlayer

var projectile_scene: PackedScene = preload("res://entities/enemies/potion_thrower/projectile/potion_projectile.tscn")

@onready var target_direction: Node3D = $TargetDirection


func _attack() -> void:
	var projectile: RigidBody3D = projectile_scene.instantiate()
	target_direction.add_child(projectile)
	projectile.top_level = true


#region Health

func _on_health_depleted() -> void:
	# Disable AI tree and stop movement
	beehave_tree.disable()
	nav_agent.target_position = global_position
	
	# Play death animation
	%AnimationPlayer.play("died")

#endregion
