extends Node3D


## fireball, rock_wall, wind_blast
@export var spell_to_unlock: String = "fireball"


func _on_interact_area_3d_interacted() -> void:
	match spell_to_unlock:
		"fireball":
			Globals.fireball_unlocked = true
		"rock_wall":
			Globals.rock_wall_unlocked = true
		"wind_blast":
			Globals.wind_blast_unlocked = true
	
	Globals.spell_unlocked.emit(spell_to_unlock)
	queue_free()
