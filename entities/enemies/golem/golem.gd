extends Enemy


@export var target_direction: Node3D

var projectile_scene: PackedScene = preload("res://entities/enemies/golem/projectile/boulder_projectile.tscn")


func _melee_attack() -> void:
	print("Melee attack")


func _ranged_attack() -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	target_direction.add_child(projectile)
	projectile.top_level = true


func _on_health_depleted() -> void:
	Globals.enemies_killed += 1
	beehave_tree.disable()
	movement_enabled = false
	
	await get_tree().create_timer(1.0).timeout
	queue_free()
