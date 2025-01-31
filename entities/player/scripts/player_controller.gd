extends RigidBody3D


@export_file("*.tscn") var hud_scene: String

@export_group("Input")
var camera_sensitivity: float = 0.1
var move_input: Vector2 = Vector2.ZERO

@export_group("Movement")
# FIXME: Player has too much speed in the air so they can slide up steep slopes
# The issue can be fixed with lower air accel at the cost of air control
@export var max_speed: float = 6.0
@export var ground_accel: float = 500.0
@export var air_accel: float = 200.0
@export var jump_force: float = 8.0
@export var max_slope_angle: float = 40.0
var is_grounded: bool = false
var ground_normal: Vector3 = Vector3.UP
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
@export var ground_check: RayCast3D
@export var interact_ray: RayCast3D
@export var spell_manager: Node3D
@export var animation_tree: AnimationTree


func _ready() -> void:
	# Load config settings
	ConfigHandler.input_settings_changed.connect(_load_input_settings)
	_load_input_settings()
	
	# Capture mouse when game begins
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Connect signals
	Globals.checkpoint_loaded.connect(_on_checkpoint_loaded)
	Globals.spell_unlocked.connect(_on_spell_unlocked)
	
	# Spawn hud
	Globals.main_scene.change_ui_scene(hud_scene)


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
		
		if event.is_action_pressed("interact"):
			interact_ray.interact_with_target()
		
		# Spell inputs
		if event.is_action_pressed("fireball") and Globals.fireball_unlocked:
			spell_manager.cast_fireball()
			animation_tree.set("parameters/fireball_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
		if event.is_action_pressed("rock_wall") and Globals.rock_wall_unlocked:
			# Spawn rock wall preview
			spell_manager.spawn_rock_wall_preview()
		elif event.is_action_released("rock_wall") and Globals.rock_wall_unlocked:
			# Spawn rock wall
			spell_manager.spawn_rock_wall()
			animation_tree.set("parameters/rock_wall_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
		if event.is_action_pressed("wind_blast") and Globals.wind_blast_unlocked:
			spell_manager.cast_wind_blast()
			animation_tree.set("parameters/wind_blast_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
		# Get move_input
		move_input = Input.get_vector("move_l", "move_r", "move_f", "move_b")
	
	else:
		move_input = Vector2.ZERO


#@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	is_grounded = _is_on_walkable_slope()
	camera.apply_camera_tilt(linear_velocity, move_direction, delta)
	if is_grounded and check_for_ground:
		camera.head_bobbing(linear_velocity, delta)
		gravity_scale = 0.1
		ground_check.target_position = to_local(global_position + (Vector3.DOWN * (rest_height + ground_buffer)))
	else:
		gravity_scale = 1.0
		ground_check.target_position = to_local(global_position + (Vector3.DOWN * rest_height))
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
			_snap_to_ground(delta)
	else:
		var target_vel: Vector3 = move_direction * max_speed
		var gravity_vector: Vector3 = linear_velocity.dot(Vector3.DOWN) * Vector3.DOWN
		var needed_vel: Vector3 = target_vel - (linear_velocity - gravity_vector)
		apply_central_force(needed_vel * air_accel * delta * mass)


func _load_input_settings() -> void:
	var input_settings: Dictionary = ConfigHandler.load_input_settings()
	camera_sensitivity = input_settings.camera_sensitivity


func _on_checkpoint_saved() -> void:
	print("Checkpoint saved")


func _on_checkpoint_loaded() -> void:
	print("Checkpoint loaded")


func _on_spell_unlocked(_spell: String) -> void:
	# Animations
	animation_tree.set("parameters/reset_idle_blend/blend_amount", 1.0)


#region Movement

# I feel there should be a need for delta, but i do not know where :\
# Apply a spring force to that moves the palyer towards rest_height
func _snap_to_ground(_delta: float) -> void:
	var hit_distance: float = (ground_check.global_position - ground_check.get_collision_point()).length()
	var normal_vel: float = -ground_normal.dot(linear_velocity)
	var dispalcement: float = hit_distance - rest_height
	var force: float = (spring_force * dispalcement) - (normal_vel * spring_damping)
	apply_central_force(Vector3.DOWN * force * mass)


func _is_on_walkable_slope() -> bool:
	if ground_check.is_colliding():
		ground_normal = ground_check.get_collision_normal()
		# Compare ground normal to upwards direction to get slope angle
		if ground_normal.angle_to(Vector3.UP) < deg_to_rad(max_slope_angle):
			return true
		return false
	return false


func _jump() -> void:
	if is_grounded:
		check_for_ground = false
		linear_velocity = Vector3(linear_velocity.x, jump_force, linear_velocity.z)
		await get_tree().create_timer(0.25).timeout
		check_for_ground = true

#endregion


#region Health

func _on_health_changed(current_health: float, max_health: float) -> void:
	Globals.health_bar_updated.emit(current_health / max_health)


func _on_health_depleted() -> void:
	# Disable stuff
	move_input = Vector2.ZERO
	Globals.player_died.emit()
	# Show game over screen
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Globals.main_scene.change_ui_scene("res://interface/game_over/game_over.tscn")

#endregion
