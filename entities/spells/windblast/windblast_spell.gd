extends Spell


@export var push_force: float = 10.0

@export_group(" ")
@export var shape_cast: ShapeCast3D


var effect_scene: String = "uid://dh3oppj1mqo0b"


func start_casting() -> void:
	if not can_cast_spell:
		return
	
	# Spell effect
	shape_cast.force_shapecast_update()
	for i: int in shape_cast.get_collision_count():
		var collider: Object = shape_cast.get_collider(i)
		var dir: Vector3 = -global_basis.z
		# Reflect projectile
		if collider is Projectile:
			if is_colliding():
				var hit_position: Vector3 = get_collision_point()
				dir = collider.global_position.direction_to(hit_position)
			collider.reflected.emit()
			collider.linear_velocity = dir * collider.initial_velocity# * collider.mass
		# Add force to rigidbodies
		elif collider is RigidBody3D:
			collider.apply_central_impulse(dir * push_force * collider.mass)
		# Apply knockback
		elif collider.has_method("recive_knockback"):
			collider.recive_knockback(dir)
	
	# Spawn effect scene
	var effect: Node3D = load(effect_scene).instantiate()
	add_child(effect)
	
	# Firerate
	can_cast_spell = false
	await get_tree().create_timer(fire_rate).timeout
	can_cast_spell = true
