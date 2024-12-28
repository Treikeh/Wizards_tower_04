extends Area3D


#FIXME: For some odd reason i cant load into "test_level" when this variable is active
@export var explosion_damage: Damage


func explode() -> void:
	var damaged_health_nodes: Array[Health] = []
	var overlapping_areas: Array[Area3D] = get_overlapping_areas()
	for area in overlapping_areas:
		if area is Hitbox:
			# Check if the health_node of the hurtbox has allready been hit
			if damaged_health_nodes.has(area.health_node):
				return
			#TODO: Check if there is line of sight to hitbox
			#TODO: Scale damage based on distance form center
			area.recive_damage(explosion_damage)
			damaged_health_nodes.append(area.health_node)
