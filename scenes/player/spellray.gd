extends RayCast3D


## Players orientation node. Used to orient Rock wall spell
## Assigned by player_controller script
var orientation: Node3D


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if rock_wall_preview != null:
		# Set rock wall preview transform
		rock_wall_preview.global_rotation = orientation.global_rotation
		if is_colliding():
			var hit_distance: float = global_position.distance_to(get_collision_point())
			if hit_distance < rock_wall_range:
				rock_wall_preview.global_position = get_collision_point()
			else:
				rock_wall_preview.global_position = global_position


#region Fireball

@export_group("Fireball")
@export var fireball_cooldown: float = 0.1
var can_fireball: bool = true
var fireball_scene: PackedScene = preload("res://scenes/spells/fireball/fireball.tscn")


func cast_fireball() -> void:
	if can_fireball:
		var fireball: RigidBody3D = fireball_scene.instantiate()
		add_child(fireball)
		fireball.basis = global_basis
		fireball.top_level = true
		
		# Cooldown
		can_fireball = false
		Globals.player_casted_spell.emit(0, fireball_cooldown)
		await get_tree().create_timer(fireball_cooldown).timeout
		can_fireball = true

#endregion


#region Rockwall

#FIXME: I need to find a way to check if there's enough space for the wall to spawn.
# The issuse isn't with spawning the wall, but with the fact that the wall will be able to move.
# If the wall is clipping into a wall or stairs when spawning it will be forced out when it -
# - starts to move, which could make the game "feel" more buggy.
# I also need to find a good way to handle the walls movement. I could use a character body, a -
# - floating rigidbody or maybe i could manually move a node3d.

@export_group("Rock wall")
@export var rock_wall_cooldown: float = 0.5
## How far away from the player the rock wall can be spawned
@export var rock_wall_range: float = 5.0
## If the palyer can cast the rock wall
var can_rock_wall: bool = true
var rock_wall_scene: PackedScene = preload("res://scenes/spells/rock_wall/rock_wall.tscn")
# Preview
var rock_wall_preview: Node3D
var rock_wall_preview_scene: PackedScene = preload("res://scenes/spells/rock_wall/rock_wall_preview.tscn")


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
	elif not rock_wall_preview.enough_space:
		# Despawn rock wall preview
		rock_wall_preview.queue_free()
		return
	
	# Spawn real rock wall
	var rock_wall: Node3D = rock_wall_scene.instantiate()
	add_child(rock_wall)
	rock_wall.top_level = true
	rock_wall.global_transform = rock_wall_preview.global_transform
	
	# Cooldown
	can_rock_wall = false
	Globals.player_casted_spell.emit(1, rock_wall_cooldown)
	# Despawn rock wall preview
	rock_wall_preview.queue_free()
	# Wait for duration before spell can be cast again
	await get_tree().create_timer(rock_wall_cooldown).timeout
	can_rock_wall = true

#endregion


#region Wind blast

@export_group("Wind blast")
@export var wind_blast_force: float = 25.0
@export var wind_blast_cooldown: float = 0.1
var can_wind_blast: bool = true
var wind_blast_effect_scene: PackedScene = preload("res://scenes/spells/wind_blast/wind_blast_effect.tscn")


func cast_wind_blast() -> void:
	if can_wind_blast:
		# Check for bodies in wind_blast area
		for body in %WindBlastArea.get_overlapping_bodies():
			print(body)
			if body is RigidBody3D:
				body.apply_central_impulse(-global_basis.z * wind_blast_force * body.mass)
			elif body.has_method("recive_knockback"):
				body.recive_knockback(-global_basis.z)
		
		# Spawn wind blast effect
		var wind_blast_effect: Node3D = wind_blast_effect_scene.instantiate()
		add_child(wind_blast_effect)
		
		# Cooldown
		can_wind_blast = false
		Globals.player_casted_spell.emit(2, wind_blast_cooldown)
		await get_tree().create_timer(wind_blast_cooldown).timeout
		can_wind_blast = true

#endregion
