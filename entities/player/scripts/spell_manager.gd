extends Node3D


## Players orientation node. Used to orient Rock wall spell
@export var orientation: Node3D


func _ready() -> void:
	fireball_info.reset()
	rock_wall_info.reset()
	wind_blast_info.reset()
	$FireballRechargeTimer.wait_time = fireball_info.recharge_duration
	$RockWallRechargeTimer.wait_time = rock_wall_info.recharge_duration
	$WindBlastRechargeTimer.wait_time = wind_blast_info.recharge_duration


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if rock_wall_preview != null:
		# Set rock wall preview transform
		rock_wall_preview.global_rotation = orientation.global_rotation
		if rock_wall_ray.is_colliding():
			var hit_distance: float = global_position.distance_to(rock_wall_ray.get_collision_point())
			if hit_distance < rock_wall_range:
				rock_wall_preview.global_position = rock_wall_ray.get_collision_point()
			else:
				rock_wall_preview.global_position = global_position


#region Fireball

@export_group("Fireball")
@export var fireball_info: SpellInfo
@export var fireball_ray: RayCast3D

var can_fireball: bool = true
var fireball_scene: PackedScene = preload("uid://cndpdurb3rxia")


func cast_fireball() -> void:
	if can_fireball and fireball_info.remaning_casts > 0:
		var fireball: RigidBody3D = fireball_scene.instantiate()
		add_child(fireball)
		fireball.top_level = true
		
		fireball_info.remaning_casts -= 1
		if $FireballRechargeTimer.is_stopped():
			$FireballRechargeTimer.start(0.0)
			Globals.spell_recharge_started.emit(0)
		
		# Cooldown
		Globals.spell_casts_updated.emit(0)
		can_fireball = false
		await get_tree().create_timer(fireball_info.firerate).timeout
		can_fireball = true


func _on_fireball_recharge_timer_timeout() -> void:
	fireball_info.remaning_casts += 1
	Globals.spell_casts_updated.emit(0)
	if fireball_info.remaning_casts < fireball_info.max_casts:
		await get_tree().process_frame
		$FireballRechargeTimer.start(0.0)
		Globals.spell_recharge_started.emit(0)

#endregion


#region Rockwall

#FIXME: I need to find a way to check if there's enough space for the wall to spawn.
# The issuse isn't with spawning the wall, but with the fact that the wall will be able to move.
# If the wall is clipping into a wall or stairs when spawning it will be forced out when it -
# - starts to move, which could make the game "feel" more buggy.
# I also need to find a good way to handle the walls movement. I could use a character body, a -
# - floating rigidbody or maybe i could manually move a node3d.

@export_group("Rock wall")
@export var rock_wall_info: SpellInfo
## How far away from the player the rock wall can be spawned
@export var rock_wall_range: float = 5.0
@export var rock_wall_ray: RayCast3D

## If the palyer can cast the rock wall
var can_rock_wall: bool = true
var rock_wall_scene: PackedScene = preload("uid://b2n0kf0vd4u8n")
# Preview
var rock_wall_preview: Node3D
var rock_wall_preview_scene: PackedScene = preload("uid://vsehaldttdcr")


func spawn_rock_wall_preview() -> void:
	if can_rock_wall and rock_wall_info.remaning_casts > 0:
		rock_wall_preview = rock_wall_preview_scene.instantiate()
		add_child(rock_wall_preview)
		rock_wall_preview.top_level = true


func spawn_rock_wall() -> void:
	# Check if there is a preview active
	if not rock_wall_preview:
		return
	# Make sure there's enough space for the wall to spawn
	#TODO: Add distance check to is_colliding part
	elif not rock_wall_preview.enough_space or not rock_wall_ray.is_colliding():
		# Despawn rock wall preview
		rock_wall_preview.queue_free()
		return
	
	# Spawn real rock wall
	var rock_wall: Node3D = rock_wall_scene.instantiate()
	add_child(rock_wall)
	rock_wall.top_level = true
	rock_wall.global_transform = rock_wall_preview.global_transform
	rock_wall_info.remaning_casts -= 1
	if $RockWallRechargeTimer.is_stopped():
		$RockWallRechargeTimer.start(0.0)
		Globals.spell_recharge_started.emit(1)
	
	# Cooldown
	can_rock_wall = false
	Globals.spell_casts_updated.emit(1)
	# Despawn rock wall preview
	rock_wall_preview.queue_free()
	# Wait for duration before spell can be cast again
	await get_tree().create_timer(rock_wall_info.firerate).timeout
	can_rock_wall = true


func _on_rock_wall_recharge_timer_timeout() -> void:
	rock_wall_info.remaning_casts += 1
	Globals.spell_casts_updated.emit(1)
	if rock_wall_info.remaning_casts < rock_wall_info.max_casts:
		await get_tree().process_frame
		$RockWallRechargeTimer.start(0.0)
		Globals.spell_recharge_started.emit(1)

#endregion


#region Wind blast

@export_group("Wind blast")
@export var wind_blast_info: SpellInfo
@export var wind_blast_force: float = 15.0
@export var wind_blast_cast: ShapeCast3D

var can_wind_blast: bool = true
var wind_blast_effect_scene: PackedScene = preload("uid://dh3oppj1mqo0b")


func cast_wind_blast() -> void:
	if can_wind_blast and wind_blast_info.remaning_casts > 0:
		# Check bodies wind_blast_cast collides with
		for i: int in wind_blast_cast.get_collision_count():
			var collider: Object = wind_blast_cast.get_collider(i)
			var dir: Vector3 = -global_basis.z
			# Reflect projectile
			if collider is Projectile:
				if fireball_ray.is_colliding():
					var hit_position = fireball_ray.get_collision_point()
					dir = collider.global_position.direction_to(hit_position)
				collider.reflected.emit()
				collider.linear_velocity = dir * collider.initial_velocity * collider.mass
			# Add force to rigidbodies
			elif collider is RigidBody3D:
				collider.apply_central_impulse(dir * wind_blast_force * collider.mass)
			# Apply knockback
			elif collider.has_method("recive_knockback"):
				collider.recive_knockback(dir)
		
		# Spawn wind blast effect
		var wind_blast_effect: Node3D = wind_blast_effect_scene.instantiate()
		add_child(wind_blast_effect)
		wind_blast_info.remaning_casts -= 1
		if $WindBlastRechargeTimer.is_stopped():
			$WindBlastRechargeTimer.start(0.0)
			Globals.spell_recharge_started.emit(2)
		
		# Cooldown
		can_wind_blast = false
		Globals.spell_casts_updated.emit(2)
		await get_tree().create_timer(wind_blast_info.firerate).timeout
		can_wind_blast = true


func _on_wind_blast_recharge_timer_timeout() -> void:
	wind_blast_info.remaning_casts += 1
	Globals.spell_casts_updated.emit(2)
	if wind_blast_info.remaning_casts < wind_blast_info.max_casts:
		await get_tree().process_frame
		$WindBlastRechargeTimer.start(0.0)
		Globals.spell_recharge_started.emit(2)

#endregion
