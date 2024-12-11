extends CharacterBody3D

@export_group("AI")
@export var chase_distance: float = 10.0
@export var vision_deg: float = 45.0
@export var nav_agent: NavigationAgent3D
var player_node: Node3D
var can_see_player: bool = false

@export_group("Movement")
@export var max_speed: float = 3.0
@export var acceleration: float = 10.0

func _ready() -> void:
	await get_tree().process_frame
	nav_agent.set_target_position(get_random_point_in_radius(global_position, 10.0))

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

#@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var direction = (nav_agent.get_next_path_position() - global_position).normalized()
	if direction:
		$Body.look_at($Body.global_position + direction)
	velocity.x = lerpf(velocity.x, direction.x * max_speed, acceleration * delta)
	velocity.z = lerpf(velocity.z, direction.z * max_speed, acceleration * delta)
	if !is_on_floor():
		velocity.y -= 9.8 * delta
	move_and_slide()

func get_random_point_in_radius(origin: Vector3, radius: float) -> Vector3:
	var x: float = randf_range(-radius, radius)
	var y: float = 0.0#randf_range(-radius, radius)
	var z: float = randf_range(-radius, radius)
	return Vector3(origin.x + x, origin.y + y, origin.z + z)

func _on_health_health_depleted() -> void:
	queue_free()

func _on_update_tick_rate_timeout() -> void:
	player_node = get_tree().get_first_node_in_group("player")
	var distance_to: float = $Body.global_position.distance_to(player_node.global_position)
	var dir_to: Vector3 = $Body.global_position.direction_to(player_node.global_position)
	var look_dot: float = dir_to.dot(-$Body.global_basis.z)
	if look_dot > deg_to_rad(vision_deg) and distance_to < chase_distance:
		%AiStateLabel.text = "Chasing"
		nav_agent.target_position = player_node.global_position
		if nav_agent.is_target_reached():
			print("ATTACK")
	else:
		%AiStateLabel.text = "Patroling"
		if nav_agent.is_target_reached():
			nav_agent.set_target_position(get_random_point_in_radius(global_position, 10.0))
