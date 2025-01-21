extends Enemy


@export_group("Movement")
@export var max_speed: float = 3.0
@export var acceleration: float = 10.0

@export_group("Nodes")
@export var mesh: Node3D
@export var target_direction: Node3D
@export var animation_tree: AnimationTree
@export var beehave_tree: BeehaveTree


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Orient mesh towards target
	var target_node: Node3D = beehave_tree.blackboard.get_value(&"target")
	if is_instance_valid(target_node):
		target_direction.look_at(target_node.global_position)
	# Rotate mesh
	mesh.rotation.y = lerp_angle(mesh.rotation.y, target_direction.rotation.y, 5.0 * delta)
	
	# Idle -> walk animation blend
	animation_tree.set("parameters/walk_blend/blend_amount", move_dir.length())


func _physics_process(delta: float) -> void:
	if not nav_agent.is_target_reached():
		move_dir = (nav_agent.get_next_path_position() - global_position).normalized()
	
	# Update velocity
	if not receiving_knockback:
		velocity.x = lerp(velocity.x, move_dir.x * max_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, move_dir.z * max_speed, acceleration * delta)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity_force * delta
	
	move_and_slide()


func _attack() -> void:
	# Play attack animation and sound
	animation_tree.set("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	#TODO: Audio
	
	# Launch enemy towards target
	recive_knockback(-target_direction.global_basis.z)


#region Health

func _on_health_depleted() -> void:
	# Disable AI and movement
	beehave_tree.disable()
	nav_agent.target_position = global_position
	
	# Play death animation and sound
	animation_tree.set("parameters/died/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	#TODO: Audio
	

#endregion
