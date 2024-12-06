extends RigidBody3D

@export var initial_velocity: float = 10.0
@export var damage_amount: float = 10.0

#var instigator: Node3D

func _ready() -> void:
	apply_central_impulse(-global_basis.z * initial_velocity)

func _on_body_entered(_body: Node) -> void:
	queue_free()

func _on_collision_area_entered(area: Node) -> void:
	if area is Hitbox:# and area.owner != instigator:
		area.recive_damage(10.0)
		queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()
