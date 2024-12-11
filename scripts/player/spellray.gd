extends RayCast3D

#region Fireball

@export_group("Fireball")
@export var fireball_damage: Damage
@export var fireball_speed: float = 20.0
@export var fireball_gravity_scale: float = 0.0
@export var fireball_cooldown: float = 0.1
var can_fireball: bool = true
var fireball_scene: PackedScene = preload("res://scenes/spells/fireball.tscn")

func cast_fireball() -> void:
	if can_fireball:
		var fireball: RigidBody3D = fireball_scene.instantiate()
		fireball.damage = fireball_damage
		fireball.initial_velocity = fireball_speed
		fireball.gravity_scale = fireball_gravity_scale
		add_child(fireball)
		fireball.basis = global_basis
		fireball.top_level = true
		can_fireball = false
		await get_tree().create_timer(fireball_cooldown).timeout
		can_fireball = true

#endregion


#region Rockwall

@export_group("Rock wall")
@export var rock_wall_cooldown: float = 0.2
var can_rock_wall: bool = true
var rock_wall_scene: PackedScene = preload("res://scenes/spells/rock_wall.tscn")

func cast_rock_wall(spawn_rotation: Vector3) -> void:
	if is_colliding() and can_rock_wall:
		var rock_wall: Node3D = rock_wall_scene.instantiate()
		add_child(rock_wall)
		rock_wall.top_level = true
		rock_wall.global_position = get_collision_point()
		rock_wall.global_rotation = spawn_rotation
		can_rock_wall = false
		await get_tree().create_timer(rock_wall_cooldown).timeout
		can_rock_wall = true

#endregion

#region Wind blast

@export_group("Wind blast")
@export var wind_force: float = 75.0
@export var wind_blast_cooldown: float = 0.1
var can_wind_blast: bool = true
var wind_blast_scene: PackedScene = preload("res://scenes/spells/wind_blast.tscn")

func cast_wind_blast() -> void:
	if can_wind_blast:
		var wind_blast: Node3D = wind_blast_scene.instantiate()
		wind_blast.force = wind_force
		add_child(wind_blast)
		can_wind_blast = false
		await get_tree().create_timer(wind_blast_cooldown).timeout
		can_wind_blast = true

#endregion
