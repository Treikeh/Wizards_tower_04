extends RigidBody3D

@export_group("Input")
@export var camera_sensitivity: float = 0.1
var move_input: Vector2 = Vector2.ZERO

@export_group("Movement")
@export var max_speed: float = 5.0
@export var ground_accel: float = 200.0
@export var air_accel: float = 100.0
@export var jump_force: float = 10.0
@export var max_slope_angle: float = 40.0
var is_grounded: bool = false
var gravity_direction: Vector3 = Vector3.DOWN
var ground_normal: Vector3 = Vector3.UP
var move_direction: Vector3 = Vector3.ZERO

# Custom gravity. NOT IN USE
var rot_speed: float = 5.0
var rot_basis: Basis

@export_group("Spring force")
@export var rest_height: float = 1.0
@export var ground_buffer: float = 0.5
@export var spring_force: float = 150.0
@export var spring_damping: float = 25.0
var check_for_ground: bool = true

@export_group("Nodes")
@export var orientation: Node3D
@export var head: Node3D
@export var camera: Node3D
@export var ground_check: RayCast3D
@export var interact_ray: RayCast3D
@export var spell_ray: RayCast3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate camera
		if event is InputEventMouseMotion:
			orientation.rotate_object_local(Vector3.UP, -deg_to_rad(event.relative.x * camera_sensitivity))
			head.rotate_object_local(Vector3.RIGHT, -deg_to_rad(event.relative.y * camera_sensitivity))
			head.rotation.x = clampf(head.rotation.x, -deg_to_rad(89), deg_to_rad(89))
		
		if event.is_action_pressed("jump"):
			jump()
		
		if event.is_action_pressed("interact"):
			interact_ray.interact_with_target()
		
		if event.is_action_pressed("attack"):
			spell_ray.cast_fireball()
		
		if event.is_action_pressed("attack_2"):
			spell_ray.cast_rock_wall()
		
		move_input = Input.get_vector("move_l", "move_r", "move_f", "move_b")

func _process(delta: float) -> void:
	is_grounded = is_on_walkable_slope()
	# Camera tilt and head bobbing
	camera.apply_camera_tilt(linear_velocity, move_direction, delta)
	if is_grounded and check_for_ground:
		camera.head_bobbing(linear_velocity, delta)
		gravity_scale = 0.1
		ground_check.target_position = to_local(global_position + (gravity_direction * (rest_height + ground_buffer)))
	else:
		gravity_scale = 1.0
		ground_check.target_position = to_local(global_position + (gravity_direction * rest_height))
	# Align move_input to look dir
	move_direction = orientation.global_basis * Vector3(move_input.x, 0.0, move_input.y).normalized()

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
		var needed_vel: Vector3 = target_vel - linear_velocity
		# FIXME: Add normal gravity to needed_vel
		apply_central_force(needed_vel * air_accel * delta * mass)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	return # Remove this line for custom gravity support
	@warning_ignore("unreachable_code")
	var grav_vec: Vector3 = state.total_gravity.normalized()
	if gravity_direction != grav_vec:
		gravity_direction = grav_vec
		var forward_dir: Vector3 = global_basis.z
		var upwards_dir: Vector3 = -gravity_direction
		var left_dir: Vector3 = upwards_dir.cross(forward_dir)
		rot_basis = Basis(left_dir, upwards_dir, forward_dir).orthonormalized()
	state.transform.basis = basis.slerp(rot_basis, rot_speed * state.step)

func snap_to_ground(_delta: float) -> void:
	var hit_distance: float = (ground_check.global_position - ground_check.get_collision_point()).length()
	var normal_vel: float = -ground_normal.dot(linear_velocity)
	var dispalcement: float = hit_distance - rest_height
	var force: float = (spring_force * dispalcement) - (normal_vel * spring_damping)
	apply_central_force(gravity_direction * force * mass)

func is_on_walkable_slope() -> bool:
	if ground_check.is_colliding():
		ground_normal = ground_check.get_collision_normal()
		if ground_normal.angle_to(-gravity_direction) < deg_to_rad(max_slope_angle):
			return true
		else:
			return false
	return false

func jump() -> void:
	if is_grounded:
		check_for_ground = false
		apply_central_impulse(-gravity_direction * jump_force)
		await get_tree().create_timer(0.25).timeout
		check_for_ground = true
