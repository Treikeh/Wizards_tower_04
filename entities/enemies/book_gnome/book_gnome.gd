extends Enemy


@export_group("Movement")
@export var max_speed: float = 3.0
@export var acceleration: float = 10.0

@export_group("Nodes")
@export var mesh: Node3D
@export var face_direction: Node3D
@export var animation_tree: AnimationTree


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Orient mesh towards target
	var target_node: Node3D = get_tree().get_first_node_in_group("player")
	if is_instance_valid(target_node):
		face_direction.look_at(target_node.global_position)
	
	mesh.rotation.y = lerp_angle(mesh.rotation.y, face_direction.rotation.y, 5.0 * delta)


func _physics_process(delta: float) -> void:
	if not navigation.is_target_reached():
		move_dir = (navigation.get_next_path_position() - global_position).normalized()
	
	# Update velocity
	if not receiving_knockback:
		velocity.x = lerp(velocity.x, move_dir.x * max_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, move_dir.z * max_speed, acceleration * delta)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity_force * delta
	
	move_and_slide()


func _attack() -> void:
	animation_tree.set("parameters/conditions/attacking", true)
	recive_knockback(-face_direction.global_basis.z)


#region Health

func _on_health_depleted() -> void:
	# Disable behavior tree
	# Stop navigation agent
	navigation.target_position = global_position
	# Play death animation
	animation_tree.set("parameters/conditions/dead", true)

#endregion
