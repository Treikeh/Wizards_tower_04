extends Enemy


@export_group("AI")
@export var chase_range: float = 10.0
@export var attack_range: float = 2.0
@export var attack_damage: Damage
@export var behavior_tree: BTPlayer

@export_group("Movement")
@export var max_speed: float = 3.0
@export var acceleration: float = 10.0
var gravity_force: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_group("Nodes")
@export var mesh: Node3D
@export var animation_player: AnimationPlayer


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var player_node: Node3D = get_tree().get_first_node_in_group("player")
	if !animation_player.is_playing():
		mesh.look_at(player_node.global_position)


func _physics_process(delta: float) -> void:
	move_dir = (navigation.get_next_path_position() - global_position).normalized()
	velocity = move_dir * max_speed
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity_force * delta
	
	if not navigation.is_target_reached():
		move_and_slide()


#region Health

func _on_health_depleted() -> void:
	behavior_tree.active = false
	animation_player.play("died")

#endregion
