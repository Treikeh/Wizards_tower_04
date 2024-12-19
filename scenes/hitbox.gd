extends Area3D
class_name Hitbox
## Recives damage. Added to characters and objects that has health

signal damage_recived(damage: Damage)

@export var health_node: Health
@export var damage_mult: float = 1.0

func recive_damage(damage: Damage) -> void:
	damage.amount *= damage_mult
	damage_recived.emit(damage)
	health_node.take_damage(damage)
