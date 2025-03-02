extends Spell


@export_group(" ")
@export var spawn_position: Marker3D

var projectile_scene: String = "uid://b4vf857hw3whd"


func start_casting() -> void:
	if not can_cast_spell:
		return
	
	force_raycast_update()
	
	# Rotate spawn_position towards raycast hit target
	var look_pos: Vector3 = to_global(target_position)
	if is_colliding():
		look_pos = get_collision_point()
	spawn_position.look_at(look_pos)
	
	# Spawn projectile
	var projectile: Projectile = load(projectile_scene).instantiate()
	spawn_position.add_child(projectile)
	projectile.top_level = true
	
	# Fire rate
	can_cast_spell = false
	await get_tree().create_timer(fire_rate).timeout
	can_cast_spell = true
