class_name HealthArea3D
extends Area3D
## Area3D that reference a Health node and can recive damage. Add to characters and objects that has health


## Emitted when a hit is registered. Will emit even if no health_node has been assigned
signal hit


## Health node to send damage info to.
@export var health_node: Health
@export var damage_multiplier: float = 1.0


func recive_damage(amount: float, type: Damage.Type) -> void:
	hit.emit()
	if not health_node:
		return
	
	amount *= damage_multiplier
	health_node.take_damage(amount, type)
