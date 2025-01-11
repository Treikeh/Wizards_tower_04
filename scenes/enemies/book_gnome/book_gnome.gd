extends Enemy


@export_group("Movement")
@export var max_speed: float = 3.0
@export var acceleration: float = 10.0

@export_group("Nodes")
@export var mesh: Node3D
@export var animation_tree: AnimationTree


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Orient mesh towards target
	var target_node: Node3D = behavior_tree.blackboard.get_var(&"player")
	if is_instance_valid(target_node) and not animation_tree.get("parameters/conditions/attacking"):
		#TODO: Find a better way of rotating the mesh towards the target
		mesh.look_at(target_node.global_position)


func _physics_process(delta: float) -> void:
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
	recive_knockback(-mesh.global_basis.z)


#region Health

func _on_health_depleted() -> void:
	# Disable behavior tree
	behavior_tree.active = false
	# Stop navigation agent
	navigation.target_position = global_position
	# Play death animation
	animation_tree.set("parameters/conditions/dead", true)

#endregion
