extends Node3D


func _on_health_area_3d_damage_recived(damage: Damage) -> void:
	match damage.type:
		Damage.Type.FIRE:
			queue_free()
