class_name Enemy
extends CharacterBody3D


@export var nav_agent: NavigationAgent3D

var move_dir: Vector3

var receiving_knockback: bool = false
var knockback_duration: float = 0.5
var gravity_force: float = ProjectSettings.get_setting("physics/3d/default_gravity")


#TODO: Make knockback NOT time based
func recive_knockback(direction: Vector3, force: float = 10.0) -> void:
	receiving_knockback = true
	velocity = direction * force
	await get_tree().create_timer(knockback_duration).timeout
	receiving_knockback = false
