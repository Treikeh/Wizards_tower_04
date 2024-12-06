@tool
extends EditorScript

func _run() -> void:
	# Convert damage mult into damage resistance
	#var damage_mult: float = 0.0
	#damage_mult = 1.0 - damage_mult
	#print("Damage resistance: " + str(damage_mult))
	
	# Convert damage resistance into damage mult
	var damage_resistance: float = 100.0
	damage_resistance = 1.0 - (damage_resistance / 100.0)
	print("Damage resistance: " + str(damage_resistance))
