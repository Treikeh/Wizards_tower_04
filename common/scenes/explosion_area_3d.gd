extends Area3D
#TODO: Replace this scripts class with a shapecast3D


@export_file("*.tscn") var vfx_scene: String
@export var damage: Damage


func trigger() -> void:
	# Deal damage
	var overlapping_areas: Array[Area3D] = get_overlapping_areas()
	var damaged_health_nodes: Array[Health] = []
	for area in overlapping_areas:
		if area is HealthArea3D:
			# Check if the health_node of the hurtbox has allready been hit
			if damaged_health_nodes.has(area.health_node):
				return
			#TODO: Line of sight check
			#TODO: Scale damage based on distance form center
			area.recive_damage(damage)
			damaged_health_nodes.append(area.health_node)
	
	#var overlapping_bodies: Array[Node3D] = get_overlapping_bodies()
	#for body in overlapping_bodies:
		#if body is RigidBody3D:
			#var dir: Vector3 = global_position.direction_to(body.global_position)
			#body.apply_central_impulse(dir * 10.0)
	
	# Spawn vfx
	var vfx: GPUParticles3D = LevelManager.add_3d_scene(vfx_scene, global_position)
	vfx.finished.connect(vfx.queue_free)
	#TODO: Scale vfx to match explosion damage area
	vfx.restart()
