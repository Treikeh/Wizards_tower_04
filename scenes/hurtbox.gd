extends Area3D
class_name Hurtbox
## Deals damage. Added to projectiles and environment hazzards

#TODO: Find a better name for signal
## Emitted when this Hurtbox collides with a Hitbox.
signal collided_with_hitbox(hitbox: Hitbox)

@export var damage: Damage

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is Hitbox:
		area.recive_damage(damage)
		collided_with_hitbox.emit(area)
