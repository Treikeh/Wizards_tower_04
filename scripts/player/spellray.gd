extends RayCast3D

#region Fireball

@export_group("Fireball")
@export var fireball_damage: Damage
@export var fireball_speed: float = 20.0
@export var fireball_gravity_scale: float = 0.0

var fireball_scene: PackedScene = preload("res://scenes/spells/fireball.tscn")

func cast_fireball() -> void:
	var fireball: RigidBody3D = fireball_scene.instantiate()
	fireball.damage = fireball_damage
	fireball.initial_velocity = fireball_speed
	fireball.gravity_scale = fireball_gravity_scale
	add_child(fireball)
	fireball.basis = global_basis
	fireball.top_level = true

#endregion


#region Rockwall

@export_group("Rock wall")
var rock_wall_scene: PackedScene = preload("res://scenes/spells/rock_wall.tscn")

func cast_rock_wall(spawn_rotation: Vector3) -> void:
	if is_colliding():
		var rock_wall: Node3D = rock_wall_scene.instantiate()
		add_child(rock_wall)
		rock_wall.top_level = true
		rock_wall.global_position = get_collision_point()
		rock_wall.global_rotation = spawn_rotation

#endregion
