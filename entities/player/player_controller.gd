extends RigidBody3D


@export_group("Input")
var camera_sensitivity: float = 0.1
var move_input: Vector2 = Vector2.ZERO

@export_group("Movement")
@export var max_speed: float = 6.0
@export var ground_accel: float = 500.0
@export var air_accel: float = 200.0
@export var jump_force: float = 8.0
@export var max_slope_angle: float = 40.0
@export var footsteps_audio_player: AudioStreamPlayer
@export var jump_audio_player: AudioStreamPlayer
@export var land_audio_player: AudioStreamPlayer

const COYOTE_TIME_DURATION: float = 0.2
const JUMP_BUFFER_DURATION: float = 0.15

var is_grounded: bool = false
var coyote_time: float = 0.0
var jump_buffer: float = 0.0
var ground_normal: Vector3 = Vector3.UP
var ground_vel: Vector3 = Vector3.ZERO
var move_direction: Vector3 = Vector3.ZERO

@export_group("Spring force")
@export var rest_height: float = 1.0
@export var ground_buffer: float = 0.5
@export var spring_force: float = 300.0
@export var spring_damping: float = 25.0
var check_for_ground: bool = true

@export_group("Nodes")
@export var orientation: Node3D
@export var head: Node3D
@export var camera: Camera3D
@export var ground_ray: RayCast3D
@export var interact_ray: RayCast3D
@export var spell_manager: Node3D
@export var animation_tree: AnimationTree

var hud_scene: String = "uid://bsrvl85f7jxdv"


func _ready() -> void:
	# Load config settings
	ConfigHandler.input_settings_changed.connect(_load_input_settings)
	_load_input_settings()
	
	# Capture mouse when game begins
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Spawn hud
	UiManager.change_ui_scene(hud_scene)
	
	#NOTE: This is stupid
	$Health.current_health = Globals.player_health
	$Health.health_changed.emit($Health.current_health, $Health.max_health)
	
	# Hide fps arms when spawning player if no spells are choosen
	if Globals.choosen_spells.is_empty():
		animation_tree.set("parameters/reset_idle_blend/blend_amount", 0.0)


func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate camera
		if event is InputEventMouseMotion:
			orientation.rotate_object_local(Vector3.UP, -deg_to_rad(event.relative.x * camera_sensitivity))
			head.rotate_object_local(Vector3.RIGHT, -deg_to_rad(event.relative.y * camera_sensitivity))
			head.rotation.x = clampf(head.rotation.x, -deg_to_rad(89), deg_to_rad(89))
		
		# jump input
		if event.is_action_pressed("jump"):
			_jump()
		
		# Interact input
		if event.is_action_pressed("interact"):
			interact_ray.interact_with_target()
		
		# Spell inputs
		if event.is_action_pressed("primary_fire"):
			spell_manager.start_casting_primary_spell()
		elif event.is_action_released("primary_fire"):
			spell_manager.stop_casting_primary_spell()
		
		if event.is_action_pressed("secondary_fire"):
			spell_manager.start_casting_secondary_spell()
		elif event.is_action_released("secondary_fire"):
			spell_manager.stop_casting_secondary_spell()
		
		# Get move_input
		move_input = Input.get_vector("move_l", "move_r", "move_f", "move_b")
	
	else:
		move_input = Vector2.ZERO


func _process(delta: float) -> void:
	camera.apply_camera_tilt(linear_velocity - ground_vel, move_direction, delta)
	if is_grounded and check_for_ground:
		camera.head_bobbing(linear_velocity - ground_vel, delta)
	
	# Align move_input to orientation
	move_direction = orientation.global_basis * Vector3(move_input.x, 0.0, move_input.y).normalized()


func _physics_process(delta: float) -> void:
	is_grounded = _is_on_walkable_slope()
	if is_grounded:
		gravity_scale = 0.1
		ground_vel = get_ground_vel()
		var slope_dir: Vector3 = move_direction.slide(ground_normal)
		var target_vel: Vector3 = slope_dir * max_speed
		var needed_vel: Vector3 = target_vel - (linear_velocity - ground_vel)
		apply_central_force(needed_vel * ground_accel * delta * mass)
		if check_for_ground:
			# Check if player just landed
			if ground_ray.target_position.y > -(rest_height + ground_buffer):
				land_audio_player.play()
				coyote_time = 0.0
				if jump_buffer > 0.0:
					jump_buffer = 0.0
					_jump()
			# Give ground_ray a buffer while grounded to allow snapping when walking down ledges
			ground_ray.target_position.y = -(rest_height + ground_buffer)
			_snap_to_ground(delta)
		else:
			# Reduce ground_shape size while airborne to get more accurate landing collision
			ground_ray.target_position.y = -rest_height
	else:
		gravity_scale = 1.0
		var target_vel: Vector3 = move_direction * max_speed
		#Bad fix for sliding up steep slopes while in the air
		#NOTE: With this fix i have even more of a reason to use a shape cast as ground check
		var slope_normal: Vector3 = Vector3.ZERO
		if move_direction and $ShapeCast3D.is_colliding():
			slope_normal = $ShapeCast3D.get_collision_normal(0)
			slope_normal = Vector3(slope_normal.x, 0.0, slope_normal.z)
			target_vel = (move_direction + slope_normal) * max_speed
		var gravity_vector: Vector3 = linear_velocity.dot(Vector3.DOWN) * Vector3.DOWN
		var needed_vel: Vector3 = target_vel - (linear_velocity - gravity_vector)
		apply_central_force(needed_vel * air_accel * delta * mass)
		
		coyote_time += delta
		jump_buffer -= delta
		
		# Reduce ground_shape size while airborne to get more accurate landing collision
		ground_ray.target_position.y = -rest_height
		ground_vel = Vector3.ZERO


func _load_input_settings() -> void:
	var input_settings: Dictionary = ConfigHandler.load_input_settings()
	camera_sensitivity = input_settings.camera_sensitivity


#region Movement


func _jump() -> void:
	if coyote_time < COYOTE_TIME_DURATION:
		coyote_time = COYOTE_TIME_DURATION
		check_for_ground = false
		linear_velocity = Vector3(linear_velocity.x, jump_force, linear_velocity.z) + ground_vel
		jump_audio_player.play()
		await get_tree().create_timer(0.25).timeout
		check_for_ground = true
	elif not is_grounded:
		jump_buffer = JUMP_BUFFER_DURATION


# I feel there should be a need for delta, but i do not know where :\
# Apply a spring force to that moves the palyer towards rest_height
func _snap_to_ground(_delta: float) -> void:
	var hit_distance: float = (ground_ray.global_position - ground_ray.get_collision_point()).length()
	var normal_vel: float = -ground_normal.dot(linear_velocity - ground_vel)
	var dispalcement: float = hit_distance - rest_height
	var force: float = (spring_force * dispalcement) - (normal_vel * spring_damping)
	apply_central_force(Vector3.DOWN * force * mass)


func _is_on_walkable_slope() -> bool:
	#TODO: Find the proper place for this. This is to allow the rock wall to launch the player ->
	# <- Without having crazy spaghetti code
	if linear_velocity.y >= jump_force:
		return false
	if ground_ray.is_colliding():
		ground_normal = ground_ray.get_collision_normal()
		# Compare ground normal to upwards direction to get slope angle
		if ground_normal.angle_to(Vector3.UP) < deg_to_rad(max_slope_angle):
			return true
		return false
	return false


func get_ground_vel() -> Vector3:
	var collider: Object = ground_ray.get_collider()
	var point: Vector3 = ground_ray.get_collision_point()
	if collider is RigidBody3D:
		return get_rigidbody_point_velocity(point, collider)
	return Vector3.ZERO


func get_rigidbody_point_velocity(point: Vector3, body: RigidBody3D) -> Vector3:
	return body.linear_velocity + body.angular_velocity.cross(point - body.transform.origin)


# Play foot steps sounds
func _on_camera_hb_trough_reached() -> void:
	footsteps_audio_player.pitch_scale = randf_range(0.5, 1.5)
	footsteps_audio_player.play()


#endregion


#region Health


func _on_health_damage_taken(damage: Damage) -> void:
	if damage.type == Damage.Type.HEALING:
		return
	%ShakeableCamera.add_camera_shake(damage.amount / 50.0)


func _on_health_changed(current_health: float, max_health: float) -> void:
	Globals.health_bar_updated.emit(current_health / max_health)
	Globals.player_health = current_health


func _on_health_depleted() -> void:
	# Disable stuff
	move_input = Vector2.ZERO
	Globals.player_died.emit()
	# Show game over screen
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	UiManager.change_ui_scene("res://interface/game_over/game_over.tscn")


#endregion
