extends Node3D


## 0 = fireball, 1 = rock wall, 2 = wind blas
@export_range(0, 2) var spell_to_unlock: int = 0


func _on_interact_area_3d_interacted() -> void:
	match spell_to_unlock:
		0:
			Globals.fireball_unlocked = true
		1:
			Globals.rock_wall_unlocked = true
		2:
			Globals.wind_blast_unlocked = true
	
	queue_free()
