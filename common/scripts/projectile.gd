class_name Projectile
extends RigidBody3D


## Emitted when reflceted by a spell (windblast, etc...)
@warning_ignore("unused_signal")
signal reflected


@export var apply_force_when_ready: bool = true
@export var initial_velocity: float = 10.0


func _ready() -> void:
	if apply_force_when_ready:
		apply_central_impulse(-global_basis.z * initial_velocity * mass)
