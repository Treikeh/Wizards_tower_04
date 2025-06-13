extends ShapeCast3D


@export var damage: Damage
@export var damage_falloff: Curve

var vfx_scene: String = "uid://dwtlgghlk0gtn"

@onready var line_of_sight: RayCast3D = $LineOfSight


func trigger() -> void:
	# Deal damage
	var damaged_health_nodes: Array[Health] = []
	force_shapecast_update()
	for i: int in get_collision_count():
		var collider: Object = get_collider(i)
		
		# Check line of sight
		line_of_sight.target_position = to_local(collider.global_position)
		line_of_sight.force_raycast_update()
		if line_of_sight.is_colliding():
			continue
		
		if collider is HealthArea3D:
			# Check if the health_node of the hurtbox has allready been hit
			if damaged_health_nodes.has(collider.health_node):
				continue
			
			# Scale damage based on sitance form center
			var distance: float = line_of_sight.target_position.length()
			# Remap distance so it works with the damage_curve
			distance = remap(distance, 0.5, shape.radius, 0.0, 1.0)
			var damage_scale: float = damage_falloff.sample(distance)
			
			collider.recive_damage(damage.amount * damage_scale, damage.type)
			damaged_health_nodes.append(collider.health_node)
	
	# Spawn vfx
	var vfx: GPUParticles3D = LevelManager.add_3d_scene(vfx_scene, global_position)
	vfx.finished.connect(vfx.queue_free)
	#TODO: Scale vfx to match explosion damage area
	vfx.restart()
