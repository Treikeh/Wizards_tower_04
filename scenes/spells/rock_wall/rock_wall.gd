extends Node3D

var lifetime: float = 10.0

# Explosion
## Minnimum amount of damage needed to trigger explosion
var damage_threshold: float = 10.0
var is_timed_explosion: bool = false
var explosion_scene: PackedScene = preload("res://scenes/spells/rock_wall/rock_wall_explosion.tscn")

@export_group("Nodes")
@export var wall_mesh: Node3D

func _ready() -> void:
	# Despawwn wall after duration runs out
	get_tree().create_timer(lifetime).timeout.connect(spell_duration_over)

# When spell duration ends
func spell_duration_over() -> void:
	queue_free()


#region Health

func _on_hitbox_damage_recived(damage: Damage) -> void:
	match damage.type:
		Damage.Type.FIRE:
			if damage.amount < damage_threshold:
				return
			if !is_timed_explosion:
				print("Explosion timer started")
				is_timed_explosion = true
			else:
				print("BOOM")
				wall_destroyed()

# When wall health is depleted
func wall_destroyed() -> void:
	var explosion_effect: Node3D = explosion_scene.instantiate()
	get_tree().current_scene.world_3d.add_child(explosion_effect)
	explosion_effect.global_transform = wall_mesh.global_transform
	queue_free()

#endregion
