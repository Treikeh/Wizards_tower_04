extends RigidBody3D

@export_group("Input")
@export var camera_sensitivity: float = 0.1
var move_input: Vector2 = Vector2.ZERO

@export_group("Movement")
# FIXME: Player has too much speed in the air so they can slide up steep slopes
# The issue can be fixed with lower air accel at the cost of air control
@export var max_speed: float = 6.0
@export var ground_accel: float = 500.0
@export var air_accel: float = 200.0
@export var jump_force: float = 7.0
@export var max_slope_angle: float = 40.0
var is_grounded: bool = false
var gravity_direction: Vector3 = Vector3.DOWN
var ground_normal: Vector3 = Vector3.UP
var move_direction: Vector3 = Vector3.ZERO
# Custom gravity
@export var allow_custom_gravity: bool = false
var rot_speed: float = 5.0
var grav_quat: Quaternion

@export_group("Spring force")
@export var rest_height: float = 1.0
@export var ground_buffer: float = 0.5
@export var spring_force: float = 300.0
@export var spring_damping: float = 25.0
var check_for_ground: bool = true

@export_group("Nodes")
@export var orientation: Node3D
@export var head: Node3D
@export var camera: Node3D
@export var ground_check: RayCast3D
@export var interact_ray: RayCast3D
@export var spell_ray: RayCast3D
# Custom grav nodes
@export var grav_position: RemoteTransform3D
@export var grav_rot: Node3D

func _ready() -> void:
	# Capture mouse when game begins
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if allow_custom_gravity:
		# Set grav position
		grav_position.remote_path = grav_rot.get_path()
		# Reset grav_rot rotation
		var reset_basis: Basis
		grav_rot.global_basis = reset_basis
		grav_rot.top_level = true
		# Set rotation of "orientation" to match starting rotation. Without this the player would -
		# - always face the same direction when starting the game, even if it was rotated in the editor
		# Issue is due too custom gravity code
		var start_basis: Basis = global_basis
		orientation.global_basis = start_basis

func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate camera
		if event is InputEventMouseMotion:
			orientation.rotate_object_local(Vector3.UP, -deg_to_rad(event.relative.x * camera_sensitivity))
			head.rotate_object_local(Vector3.RIGHT, -deg_to_rad(event.relative.y * camera_sensitivity))
			head.rotation.x = clampf(head.rotation.x, -deg_to_rad(89), deg_to_rad(89))
		
		# jump input
		if event.is_action_pressed("jump"):
			jump()
		
		if event.is_action_pressed("interact"):
			interact_ray.interact_with_target()
		
		# Spell inputs
		if event.is_action_pressed("fireball"):
			spell_ray.cast_fireball()
		
		if event.is_action_pressed("rock_wall"):
			spell_ray.cast_rock_wall(orientation.global_rotation)
		
		if event.is_action_pressed("wind_blast"):
			spell_ray.cast_wind_blast()
		
		# Get move_input
		move_input = Input.get_vector("move_l", "move_r", "move_f", "move_b")

#@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	is_grounded = is_on_walkable_slope()
	camera.apply_camera_tilt(linear_velocity, move_direction, delta) # FIXME: issues with camera tilt. or not...  Why it's working fine now?
	if is_grounded and check_for_ground:
		camera.head_bobbing(linear_velocity, delta)
		gravity_scale = 0.1
		ground_check.target_position = to_local(global_position + (gravity_direction * (rest_height + ground_buffer)))
	else:
		gravity_scale = 1.0
		ground_check.target_position = to_local(global_position + (gravity_direction * rest_height))
	# Align move_input to orientation
	move_direction = orientation.global_basis * Vector3(move_input.x, 0.0, move_input.y).normalized()

#@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if is_grounded:
		ground_normal = ground_check.get_collision_normal()
		var slope_dir: Vector3 = move_direction.slide(ground_normal)
		var target_vel: Vector3 = slope_dir * max_speed
		var needed_vel: Vector3 = target_vel - linear_velocity
		apply_central_force(needed_vel * ground_accel * delta * mass)
		if check_for_ground:
			snap_to_ground(delta)
	else:
		var target_vel: Vector3 = move_direction * max_speed
		var gravity_vector: Vector3 = linear_velocity.dot(gravity_direction) * gravity_direction
		var needed_vel: Vector3 = target_vel - (linear_velocity - gravity_vector)
		apply_central_force(needed_vel * air_accel * delta * mass)

#@warning_ignore("unused_parameter")
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if !allow_custom_gravity:
		return
	# Custom gravity rotation
	var grav_vec: Vector3 = state.total_gravity.normalized()
	if gravity_direction != grav_vec:
		# Get rotatoin angle and vector
		var rot_angle: float = gravity_direction.angle_to(grav_vec)
		var rot_vec: Vector3 = gravity_direction.cross(grav_vec).normalized()
		# If gravity_direction and grav_vec are parrallel to each other, then rot_vec would be empty
		# This makes sure that there is always a axis to rotate around
		if !rot_vec:
			rot_vec = orientation.global_basis.z
		
		# Create new quaternion
		#FIXME: Rotation becomes skewed when gravity changes before rotation slerping finishes
		# The issue is releted to the fact that i am using the current global_basis as the old_quat.
		# If gravity changes while slepring rotation, the new_quat will not be correct since -
		# - the global_basis is not matcing the old gravity_directon.
		# I need to store the old_basis and use that in some way. That way when slerping stars it -
		# - will always have correct values to work with.
		var old_quat: Quaternion = global_basis.get_rotation_quaternion()
		var new_quat: Quaternion = Quaternion(rot_vec, rot_angle).normalized()
		grav_quat = new_quat * old_quat
		
		# Set gravity direction
		gravity_direction = grav_vec
	# Apply new rotation
	# I can also disconnect the rigidbody and camera. If i set the rotation of the body but -
	# - slerp the rotation of the camera it could work
	# IT WORKED. FINALY I HAVE IT.
	var current_quat: Quaternion = grav_rot.global_basis.get_rotation_quaternion()
	var slerp_quat: Quaternion = current_quat.slerp(grav_quat, rot_speed * state.step).normalized()
	# Rotate camera
	grav_rot.transform.basis = Basis(slerp_quat)
	# Rotate body
	state.transform.basis = Basis(grav_quat)


#region Movement

# I feel there should be a need for delta, but i do not know where :\
# Apply a spring force to that moves the palyer towards rest_height
func snap_to_ground(_delta: float) -> void:
	var hit_distance: float = (ground_check.global_position - ground_check.get_collision_point()).length()
	var normal_vel: float = -ground_normal.dot(linear_velocity)
	var dispalcement: float = hit_distance - rest_height
	var force: float = (spring_force * dispalcement) - (normal_vel * spring_damping)
	apply_central_force(gravity_direction * force * mass)

func is_on_walkable_slope() -> bool:
	if ground_check.is_colliding():
		ground_normal = ground_check.get_collision_normal()
		# Compare ground normal to upwards direction to get slope angle
		if ground_normal.angle_to(-gravity_direction) < deg_to_rad(max_slope_angle):
			return true
		return false
	return false

# FIXME: Make jumping consistent when moving up and down a slope
# Jumping is shorter when moving downw a slope since the palyer already has downwards force
func jump() -> void:
	if is_grounded:
		check_for_ground = false
		apply_central_impulse(-gravity_direction * jump_force)
		await get_tree().create_timer(0.25).timeout
		check_for_ground = true

#endregion


#region Health
func _on_health_changed(current_health: float, max_health: float) -> void:
	SignalHub.update_health_bar.emit(current_health / max_health)

func _on_health_depleted() -> void:
	SignalHub.player_died.emit()
#endregion
