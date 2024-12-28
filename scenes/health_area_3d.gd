class_name HealthArea3D
extends Area3D
## Area3D that reference a Health node and can recive damage. Add to characters and objects that has health

signal damage_recived(damage: Damage)

@export var health_node: Health
## Multiplies damage
@export var damage_multiplier: float = 1.0


func recive_damage(damage: Damage) -> void:
	var amount: float = damage.amount
	var type: Damage.DamageType = damage.type
	amount *= damage_multiplier
	damage_recived.emit(damage)
	health_node.take_damage(amount, type)
