class_name DamageArea3D
extends Area3D
## Area3D that needs to deal damage. Add to projectiles and environmental hazzards


## Emitted when colliding with a HealthArea3D.
signal hit_health_area(health_area: HealthArea3D)


@export var damage: Damage
@export var apply_over_time: bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _process(delta: float) -> void:
	if apply_over_time:
		var overlapping_areas: Array[Area3D] = get_overlapping_areas()
		for area in overlapping_areas:
			if area is HealthArea3D:
				area.recive_damage(damage.amount * delta, damage.type)


func _on_area_entered(area: Area3D) -> void:
	if area is HealthArea3D and not apply_over_time:
		hit_health_area.emit(area)
		area.recive_damage(damage.amount, damage.type)
