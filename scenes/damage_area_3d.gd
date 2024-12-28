class_name DamageArea3D
extends Area3D
## Area3D that needs to deal damage. Add to projectiles and environmental hazzards

#TODO: Find a better name for signal
## Emitted when this Hurtbox collides with a Hitbox.
signal collided_with_health_area(health_area: HealthArea3D)

@export var damage: Damage
@export var is_damage_over_timer: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is HealthArea3D:
		area.recive_damage(damage)
		collided_with_health_area.emit(area)
