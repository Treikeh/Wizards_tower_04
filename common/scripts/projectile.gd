class_name Projectile
extends RigidBody3D


# Could also be a function
signal reflected


@export var initial_velocity: float = 10.0


func _ready() -> void:
	apply_central_impulse(-global_basis.z * initial_velocity * mass)
	reflected.connect(_on_projectile_reflected)


func _on_projectile_reflected() -> void:
	pass
