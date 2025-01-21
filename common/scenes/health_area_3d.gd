class_name HealthArea3D
extends Area3D
## Area3D that reference a Health node and can recive damage. Add to characters and objects that has health


## Emitted when a hit is registered. Will emit even if no health_node has been assigned
signal hit


## Health node to send damage info to.
@export var health_node: Health
## Multiplies damage
@export var damage_multiplier: float = 1.0


func recive_damage(damage: Damage, duplicate_damage: bool = true) -> void:
	hit.emit()
	if not health_node:
		return
	
	if duplicate_damage:
		# Duplicate damage to avoid permanently altering damage.amout on the resource
		var new_damage: Damage = damage.duplicate()
		new_damage.amount *= damage_multiplier
		health_node.take_damage(new_damage)
	else:
		#NOTE: If the damage resrouce isn't duplicated before reaching this part. The damage.amout ->
		# <- on the resource will be modified for the rest of the game
		damage.amount *= damage_multiplier
		health_node.take_damage(damage)
