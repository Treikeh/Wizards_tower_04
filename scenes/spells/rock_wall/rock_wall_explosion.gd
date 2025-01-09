extends Area3D


#FIXME: For some odd reason i cant load into "test_level" when this variable is active
# I made the explosion a part of the rock_wall scene and now i can load into test_level
# The issue had something to do with the "preload" function
@export var explosion_damage: Damage


func explode() -> void:
	var damaged_health_nodes: Array[Health] = []
	var overlapping_areas: Array[Area3D] = get_overlapping_areas()
	for area in overlapping_areas:
		if area is HealthArea3D:
			# Check if the health_node of the hurtbox has allready been hit
			if damaged_health_nodes.has(area.health_node):
				return
			#TODO: Line of sight check
			#TODO: Scale damage based on distance form center
			var duped_damage: Damage = explosion_damage.duplicate()
			area.recive_damage(duped_damage)
			damaged_health_nodes.append(area.health_node)
