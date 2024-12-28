extends RigidBody3D


var initial_velocity: float = 10.0
var lifetime: float = 10.0

@export_group("Nodes")
@export var damage_area: DamageArea3D


func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(despawn_spell)
	apply_central_impulse(-global_basis.z * initial_velocity)


func _on_body_entered(_body: Node) -> void:
	queue_free()


func _on_damage_area_3d_collided_with_health_area(_health_area: HealthArea3D) -> void:
	despawn_spell()


func despawn_spell() -> void:
	queue_free()
