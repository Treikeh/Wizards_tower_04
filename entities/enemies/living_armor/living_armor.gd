extends Enemy


@export_group("Movement")
@export var max_speed: float = 4.0
@export var acceleration: float = 10.0

var rotation_speed: float = 5.0

@export_group("Nodes")
@export var mesh: Node3D
@export var target_direction: Node3D
@export var animation_player: AnimationPlayer
@export var beehave_tree: BeehaveTree


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var target_node: Node3D = beehave_tree.blackboard.get_value(&"target")
	if is_instance_valid(target_node):
		target_direction.look_at(target_node.global_position)
	# Rotate mesh
	mesh.rotation.y = lerp_angle(mesh.rotation.y, target_direction.rotation.y, rotation_speed * delta)


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if not nav_agent.is_target_reached():
		move_dir = (nav_agent.get_next_path_position() - global_position).normalized()
	
	if not receiving_knockback:
		velocity.x = lerp(velocity.x, move_dir.x * max_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, move_dir.z * max_speed, acceleration * delta)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity_force * delta
	
	move_and_slide()


#region Health

func _on_health_depleted() -> void:
	# Disable AI tree and stop movement
	beehave_tree.disable()
	nav_agent.target_position = global_position
	
	# Play death animation
	%AnimationPlayer.play("died")

#endregion
