class_name Enemy
extends CharacterBody3D


var receiving_knockback: bool = false
var knockback_duration: float = 0.5
var move_dir: Vector3

@export var navigation: NavigationAgent3D


func move_to(target_position: Vector3) -> void:
	navigation.target_position = target_position
	var dir: Vector3 = (navigation.get_next_path_position() - position).normalized()
	if navigation.is_target_reached():
		move_dir = Vector3.ZERO
		print("Target reached")
	else:
		move_dir = dir


func recive_knockback(direction: Vector3) -> void:
	receiving_knockback = true
	velocity = direction * 10.0
	await get_tree().create_timer(knockback_duration).timeout
	receiving_knockback = false
