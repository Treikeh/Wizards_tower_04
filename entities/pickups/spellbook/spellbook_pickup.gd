extends Node3D


@export_enum("Fireball", "Rock_wall", "Wind_blast") var spell_to_unlock: int = 0


func _on_interact_area_3d_interacted() -> void:
	match spell_to_unlock:
		0:
			Globals.fireball_unlocked = true
		1:
			Globals.rock_wall_unlocked = true
		2:
			Globals.wind_blast_unlocked = true
	
	Globals.spell_unlocked.emit(spell_to_unlock)
	queue_free()
