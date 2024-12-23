extends Node3D

var lifetime: float = 10.0

# Explosion
## Minnimum amount of damage needed to trigger explosion
var damage_threshold: float = 10.0
var is_timed_explosion: bool = false
# Might be a good idea to make the explosion a part of the scene instead of spawning it.
# Not using PackedScene since i had a few issues when loading into "test_level" and this fixed it
@export_file("*.tscn") var explosion_scene: String

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
				is_timed_explosion = true
			else:
				wall_destroyed()

# When wall health is depleted
func wall_destroyed() -> void:
	var explosion_effect: Node3D = load(explosion_scene).instantiate()
	get_tree().current_scene.world_3d.add_child(explosion_effect)
	explosion_effect.global_transform = wall_mesh.global_transform
	queue_free()

#endregion
