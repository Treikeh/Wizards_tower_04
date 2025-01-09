extends RigidBody3D


@export var initial_velocity: float = 20.0
## How long the fireball will be in the scene before despawning
@export var lifetime: float = 10.0



func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(despawn_spell)
	apply_central_impulse(-global_basis.z * initial_velocity)


func _on_body_entered(_body: Node) -> void:
	queue_free()


func _on_damage_area_3d_collided_with_health_area(_health_area: HealthArea3D) -> void:
	despawn_spell()


func despawn_spell() -> void:
	queue_free()
