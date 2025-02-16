extends Node3D


## Players orientation node. Used to orient Rock wall spell
@export var orientation: Node3D


func _ready() -> void:
	$FireballRechargeTimer.wait_time = fireball_cooldown
	$RockWallRechargeTimer.wait_time = rock_wall_cooldown
	$WindBlastRechargeTimer.wait_time = wind_blast_cooldown


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
@export var fireball_cooldown: float = 2.0
@export var fireball_firerate: float = 0.3
@export var fireball_ray: RayCast3D
@export var fireball_max_casts: int = 3
var can_fireball: bool = true
var fireball_remaning_casts: int = fireball_max_casts
var fireball_scene: PackedScene = preload("uid://cndpdurb3rxia")


func cast_fireball() -> void:
	if can_fireball and fireball_remaning_casts > 0:
		var fireball: RigidBody3D = fireball_scene.instantiate()
		add_child(fireball)
		fireball.top_level = true
		fireball_remaning_casts -= 1
		if $FireballRechargeTimer.is_stopped():
			$FireballRechargeTimer.start(0.0)
			Globals.spell_recharge_started.emit(0, fireball_cooldown)
		
		# Cooldown
		Globals.player_casted_spell.emit(0)
		can_fireball = false
		await get_tree().create_timer(fireball_firerate).timeout
		can_fireball = true


func _on_fireball_recharge_timer_timeout() -> void:
	Globals.spell_recharge_ended.emit(0)
	fireball_remaning_casts += 1
	if fireball_remaning_casts < fireball_max_casts:
		await get_tree().process_frame
		$FireballRechargeTimer.start(0.0)
		Globals.spell_recharge_started.emit(0, fireball_cooldown)

#endregion


#region Rockwall

#FIXME: I need to find a way to check if there's enough space for the wall to spawn.
# The issuse isn't with spawning the wall, but with the fact that the wall will be able to move.
# If the wall is clipping into a wall or stairs when spawning it will be forced out when it -
# - starts to move, which could make the game "feel" more buggy.
# I also need to find a good way to handle the walls movement. I could use a character body, a -
# - floating rigidbody or maybe i could manually move a node3d.

@export_group("Rock wall")
@export var rock_wall_cooldown: float = 3.0
@export var rock_wall_firerate: float = 1.5
@export var rock_wall_max_casts: int = 2
## How far away from the player the rock wall can be spawned
@export var rock_wall_range: float = 5.0
@export var rock_wall_ray: RayCast3D
## If the palyer can cast the rock wall
var can_rock_wall: bool = true
var rock_wall_remaning_casts: int = rock_wall_max_casts
var rock_wall_scene: PackedScene = preload("uid://b2n0kf0vd4u8n")
# Preview
var rock_wall_preview: Node3D
var rock_wall_preview_scene: PackedScene = preload("uid://vsehaldttdcr")


func spawn_rock_wall_preview() -> void:
	if can_rock_wall:
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
	rock_wall_remaning_casts -= 1
	if $RockWallRechargeTimer.is_stopped():
		$RockWallRechargeTimer.start(0.0)
		Globals.spell_recharge_started.emit(1, rock_wall_cooldown)
	
	# Cooldown
	can_rock_wall = false
	Globals.player_casted_spell.emit(1)
	# Despawn rock wall preview
	rock_wall_preview.queue_free()
	# Wait for duration before spell can be cast again
	await get_tree().create_timer(rock_wall_firerate).timeout
	can_rock_wall = true


func _on_rock_wall_recharge_timer_timeout() -> void:
	Globals.spell_recharge_ended.emit(1)
	rock_wall_remaning_casts += 1
	if rock_wall_remaning_casts < rock_wall_max_casts:
		await get_tree().process_frame
		$RockWallRechargeTimer.start(0.0)
		Globals.spell_recharge_started.emit(1, rock_wall_cooldown)

#endregion


#region Wind blast

@export_group("Wind blast")
@export var wind_blast_force: float = 15.0
@export var wind_blast_cooldown: float = 3
@export var wind_blast_firerate: float = 1.25
@export var wind_blast_max_casts: int = 5
@export var wind_blast_area: Area3D
var can_wind_blast: bool = true
var wind_blast_remaning_casts: int = wind_blast_max_casts
var wind_blast_effect_scene: PackedScene = preload("uid://dh3oppj1mqo0b")


func cast_wind_blast() -> void:
	if can_wind_blast:
		# Check for bodies in wind_blast area
		for body in wind_blast_area.get_overlapping_bodies():
			var dir: Vector3 = -global_basis.z
			# Reflect projectile
			if body is Projectile:
				if fireball_ray.is_colliding():
					var hit_position = fireball_ray.get_collision_point()
					dir = body.global_position.direction_to(hit_position)
				body.reflected.emit()
				body.linear_velocity = dir * body.initial_velocity * body.mass
			# Add force to rigidbodies
			elif body is RigidBody3D:
				body.apply_central_impulse(dir * wind_blast_force * body.mass)
			# Apply knockback
			elif body.has_method("recive_knockback"):
				body.recive_knockback(dir)
		
		# Spawn wind blast effect
		var wind_blast_effect: Node3D = wind_blast_effect_scene.instantiate()
		add_child(wind_blast_effect)
		wind_blast_remaning_casts -= 1
		if $WindBlastRechargeTimer.is_stopped():
			$WindBlastRechargeTimer.start(0.0)
			Globals.spell_recharge_started.emit(2, wind_blast_cooldown)
		
		# Cooldown
		can_wind_blast = false
		Globals.player_casted_spell.emit(2)
		await get_tree().create_timer(wind_blast_firerate).timeout
		can_wind_blast = true


func _on_wind_blast_recharge_timer_timeout() -> void:
	Globals.spell_recharge_ended.emit(2)
	wind_blast_remaning_casts += 1
	if wind_blast_remaning_casts < wind_blast_max_casts:
		await get_tree().process_frame
		$WindBlastRechargeTimer.start(0.0)
		Globals.spell_recharge_started.emit(2, wind_blast_cooldown)

#endregion
