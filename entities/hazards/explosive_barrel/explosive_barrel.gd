extends Node3D


@export_file("*.tscn") var explosion_vfx_scene: String


func _on_health_area_3d_damage_recived(damage: Damage) -> void:
	match damage.type:
		Damage.Type.FIRE:
			var vfx: GPUParticles3D = Globals.main_scene.add_3d_scene(explosion_vfx_scene, global_position)
			vfx.finished.connect(vfx.queue_free)
			vfx.restart()
			queue_free()
