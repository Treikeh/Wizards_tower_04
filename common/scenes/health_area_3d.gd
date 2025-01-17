class_name HealthArea3D
extends Area3D
## Area3D that reference a Health node and can recive damage. Add to characters and objects that has health

signal hit
signal damage_recived(damage: Damage)


## Health node to send damage info to.
## If unassigned this area will work as a damage trigger and still emit the "hit" signal
@export var health_node: Health
## Multiplies damage
@export var damage_multiplier: float = 1.0


func recive_damage(damage: Damage) -> void:
	hit.emit()
	if not health_node:
		return
	#NOTE: damage paramater should be duplicated before reaching this function. This is to avoid -
	# - permanently changing the damage.amount value
	damage.amount *= damage_multiplier
	damage_recived.emit(damage)
	health_node.take_damage(damage)
