class_name DamageArea3D
extends Area3D
## Area3D that needs to deal damage. Add to projectiles and environmental hazzards


## Emitted when colliding with a HealthArea3D.
signal hit_health_area(health_area: HealthArea3D)


@export var damage: Damage
## Damage over time
@export var apply_over_time: bool = false


func _process(delta: float) -> void:
	#NOTE: This works, but it probably isn't performant, A fix could be to change to a tick system
	if apply_over_time:
		var overlapping_areas: Array[Area3D] = get_overlapping_areas()
		for area in overlapping_areas:
			if area is HealthArea3D:
				var scaled_damage: Damage = damage.duplicate()
				scaled_damage.amount *= delta
				hit_health_area.emit(area)
				area.recive_damage(scaled_damage, false)


func _on_area_entered(area: Area3D) -> void:
	if area is HealthArea3D and not apply_over_time:
		# Duplicating damage resource to avoid permanently changing damage.amount if it hits a -
		# - HealthArea3D with a damage sacle other than 1.0
		hit_health_area.emit(area)
		area.recive_damage(damage)
