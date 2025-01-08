extends Enemy


@export_group("Movement")
@export var max_speed: float = 3.0
@export var acceleration: float = 10.0
var gravity_force: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_group("Nodes")
@export var mesh: Node3D
@export var animation_player: AnimationPlayer


func _ready() -> void:
	# Set enemy spawn position
	behavior_tree.blackboard.set_var("spawn_position", global_position)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var player_node: Node3D = get_tree().get_first_node_in_group("player")
	if !animation_player.is_playing() and is_instance_valid(player_node):
		mesh.look_at(player_node.global_position)


func _physics_process(delta: float) -> void:
	move_dir = (navigation.get_next_path_position() - global_position).normalized()
	# Update velocity
	if not receiving_knockback:
		velocity.x = lerp(velocity.x, move_dir.x * max_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, move_dir.z * max_speed, acceleration * delta)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity_force * delta
	
	if not navigation.is_target_reached() or receiving_knockback:
		move_and_slide()


func _attack() -> void:
	recive_knockback(-mesh.global_basis.z)


#region Health

func _on_health_depleted() -> void:
	# Disable behavior tree
	behavior_tree.active = false
	# Stop navigation agent
	navigation.target_position = global_position
	animation_player.play("died")

#endregion
