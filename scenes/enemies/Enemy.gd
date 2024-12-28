class_name Enemy
extends CharacterBody3D


var receiving_knockback: bool = false
var knockback_duration: float = 0.5

@export var nav_agent: NavigationAgent3D


func recive_knockback(direction: Vector3) -> void:
	receiving_knockback = true
	velocity = direction * 10.0
	await get_tree().create_timer(knockback_duration).timeout
	receiving_knockback = false
