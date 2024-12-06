extends Area3D
class_name Hitbox

@export var health_node: Health
@export var damage_mult: float = 1.0

func recive_damage(damage: Damage) -> void:
	damage.amount *= damage_mult
	health_node.take_damage(damage)
