extends Enemy


@export var max_spawns: int = 5

@export_group(" ")
@export var target_direction: Node3D
@export var spawn_position: Marker3D
@export var anim_player: AnimationPlayer

var book_gnomes_spawned: int = 0
var book_gnome_scene: String = "uid://uvws4xru1kpl"


func _process(_delta: float) -> void:
	# I don't like this. Don't know why, but i just don't like its
	var horizontal_vel: Vector3 = Vector3(velocity.x, 0.0, velocity.z)
	if horizontal_vel.round() != Vector3.ZERO:
		target_direction.look_at(target_direction.global_position + horizontal_vel)


func attack() -> void:
	# Spawn book gnome
	if book_gnomes_spawned < max_spawns:
		LevelManager.add_3d_scene(book_gnome_scene, spawn_position.global_position)
		book_gnomes_spawned += 1



#region Health

func _on_health_depleted() -> void:
	Globals.enemies_killed += 1
	# Disable AI tree and stop movement
	beehave_tree.disable()
	movement_enabled = false
	
	# Play death animation
	anim_player.play("died_001")

#endregion
