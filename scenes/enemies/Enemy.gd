class_name Enemy
extends CharacterBody3D


@export var navigation: NavigationAgent3D
@export var behavior_tree: BTPlayer

var receiving_knockback: bool = false
var knockback_duration: float = 0.5
var move_dir: Vector3


func recive_knockback(direction: Vector3) -> void:
	receiving_knockback = true
	velocity = direction * 10.0
	await get_tree().create_timer(knockback_duration).timeout
	receiving_knockback = false
