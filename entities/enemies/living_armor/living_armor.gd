extends Enemy


@export_group("Movement")
@export var max_speed: float = 4.0
@export var acceleration: float = 10.0


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var player_node: Node3D = get_tree().get_first_node_in_group("player")
	if not %AnimationPlayer.is_playing() and is_instance_valid(player_node):
		%Mesh.look_at(player_node.global_position)


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	move_dir = (nav_agent.get_next_path_position() - global_position).normalized()
	velocity.x = lerp(velocity.x, move_dir.x * max_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, move_dir.z * max_speed, acceleration * delta)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity_force * delta
		print("hello")
	
	if not nav_agent.is_target_reached() or receiving_knockback:
		move_and_slide()


#region Health

func _on_health_depleted() -> void:
	# Disable behavior tree
	# Stop navigation agent
	nav_agent.target_position = global_position
	%AnimationPlayer.play("died")

#endregion
