extends Node3D

var damage_amount: float = 15.0
var projectile_scene: Resource = preload("res://scenes/projectile.tscn")

func spawn_projectile() -> void:
	var projectile: RigidBody3D = projectile_scene.instantiate()
	projectile.instigator = owner
	projectile.damage_amount = damage_amount
	add_child(projectile)
	projectile.basis = global_basis
	projectile.top_level = true
