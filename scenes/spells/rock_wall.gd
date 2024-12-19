extends Node3D

var lifetime: float = 10.0
var is_timed_explosion: bool = false

func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(despawn_spell)

func _on_hitbox_damage_recived(damage: Damage) -> void:
	match damage.type:
		Damage.Type.FIRE:
			if !is_timed_explosion:
				print("Explosion timer started")
				is_timed_explosion = true
			else:
				print("BOOM")
				wall_destroyed()

# When spell duration ends
func despawn_spell() -> void:
	queue_free()

# When wall health is depleted
func wall_destroyed() -> void:
	queue_free()
