extends RigidBody3D


@export var camera: Camera3D
@export var animation_tree: AnimationTree


func _ready() -> void:
	state_machine.switch(FALLING)
	
	#NOTE: This is stupid.
	#TODO: Find a better solution.
	$Health.current_health = Globals.player_health
	$Health.health_changed.emit($Health.current_health, $Health.max_health)
	
	Globals.spells_changed.connect(_on_spells_changed)
	# Hide fps arms when spawning player if no spells are choosen
	if Globals.choosen_spells.is_empty():
		animation_tree.set("parameters/reset_idle_blend/blend_amount", 0.0)


func _process(delta: float) -> void:
	camera.apply_camera_tilt(linear_velocity, move_direction, delta)
	if ground_check.is_grounded:
		camera.head_bobbing(linear_velocity, delta)


func _physics_process(delta: float) -> void:
	# Process phycics callback on the state state machine
	state_machine.physics(delta)


func _on_spells_changed() -> void:
	animation_tree.set("parameters/reset_idle_blend/blend_amount", 1.0)

func _on_spell_manager_casted_spell(anim: String) -> void:
	animation_tree.set(anim, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


# Play foot steps sounds
func _on_camera_hb_trough_reached() -> void:
	footsteps_audio_player.pitch_scale = randf_range(0.5, 1.5)
	footsteps_audio_player.play()


#region Input

@export_group("Input")
@export var orientation: Node3D
@export var head: Node3D
@export var interact_ray: RayCast3D
@export var spell_manager: Node3D

# Camera input
func _on_input_looked(vector: Vector2) -> void:
	orientation.rotate_object_local(Vector3.UP, vector.x)
	head.rotate_object_local(Vector3.RIGHT, vector.y)
	head.rotation.x = clampf(head.rotation.x, -deg_to_rad(89), deg_to_rad(89))

func _on_input_moved(vector: Vector2) -> void:
	move_direction = orientation.global_basis * Vector3(vector.x, 0.0, vector.y).normalized()

func _on_input_jumped_toggled(pressed: bool) -> void:
	is_jumping = pressed

func _on_input_interacted() -> void:
	interact_ray.interact_with_target()

func _on_input_primary_toggled(pressed: bool) -> void:
	if pressed:
		spell_manager.start_casting_primary_spell()
	else:
		spell_manager.stop_casting_primary_spell()

func _on_input_secondary_toggled(pressed: bool) -> void:
	if pressed:
		spell_manager.start_casting_secondary_spell()
	else:
		spell_manager.stop_casting_secondary_spell()

#endregion


#region Movement

@export_group("Movement")
@export var max_speed: float = 6.0
@export var ground_accel: float = 500.0
@export var air_accel: float = 200.0
@export var jump_force: float = 8.0
@export var ground_check: ShapeCast3D
@export var footsteps_audio_player: AudioStreamPlayer
@export var jump_audio_player: AudioStreamPlayer
@export var land_audio_player: AudioStreamPlayer

const COYOTE_TIME_DURATION: float = 0.2
var coyote_time_passed: float = 0

#NOTE: Could also be placed in the input section, but i use it more in movement so it stays here.
var is_jumping: bool = false
var move_direction: Vector3 = Vector3.ZERO


enum {WALKING, FALLING, JUMPING}

var state_machine := SM.new({
	WALKING: {SM.ENTER: _walking_enter, SM.PHYSICS: _walking_physics},
	FALLING: {SM.ENTER: _falling_enter, SM.PHYSICS: _falling_physics},
	JUMPING: {SM.ENTER: _jumping_enter},
})


func _walking_enter() -> void:
	gravity_scale = 0.1
	# Give ground_check a buffer while grounded to allow snapping when walking down ledges
	ground_check.target_position.y = -1.0
	# Reset coyote time when landing.
	coyote_time_passed = 0.0
	land_audio_player.play()

func _walking_physics(delta: float) -> void:
	if not ground_check.is_grounded:
		state_machine.switch(FALLING)
		return
	
	if is_jumping:
		state_machine.switch(JUMPING)
		return
	
	var slope_dir: Vector3 = move_direction.slide(ground_check.ground_normal)
	var target_vel: Vector3 = slope_dir * max_speed
	var needed_vel: Vector3 = target_vel - linear_velocity
	apply_central_force(needed_vel * ground_accel * delta * mass)


func _falling_enter() -> void:
	gravity_scale = 1.0
	# Reduce ground_check size while airborne to get more accurate landing collision
	ground_check.target_position.y = -0.5

func _falling_physics(delta: float) -> void:
	if ground_check.is_grounded:
		state_machine.switch(WALKING)
		return
	
	if is_jumping and coyote_time_passed < COYOTE_TIME_DURATION:
		state_machine.switch(JUMPING)
	
	coyote_time_passed += delta
	
	var target_vel: Vector3 = move_direction * max_speed
	var slope_normal: Vector3 = Vector3.ZERO
	
	#Bad fix for sliding up steep slopes while in the air
	if move_direction and ground_check.is_colliding():
		slope_normal = ground_check.ground_normal
		slope_normal = Vector3(slope_normal.x, 0.0, slope_normal.z)
		target_vel = (move_direction + slope_normal) * max_speed
	
	var gravity_vector: Vector3 = linear_velocity.dot(Vector3.DOWN) * Vector3.DOWN
	var needed_vel: Vector3 = target_vel - (linear_velocity - gravity_vector)
	apply_central_force(needed_vel * air_accel * delta * mass)


func _jumping_enter() -> void:
	coyote_time_passed = COYOTE_TIME_DURATION * 2.0
	set_axis_velocity(Vector3.UP * jump_force)
	jump_audio_player.play()
	state_machine.switch(FALLING)

#endregion


#region Health

func _on_health_damage_taken(damage: Damage) -> void:
	if damage.type == Damage.Type.HEALING:
		return
	%ShakeableCamera.add_camera_shake(0.3)


func _on_health_changed(current_health: float, max_health: float) -> void:
	Globals.health_bar_updated.emit(current_health / max_health)
	Globals.player_health = current_health


func _on_health_depleted() -> void:
	# Disable stuff
	Globals.player_died.emit()
	# Show game over screen
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	UiManager.change_ui_scene("res://interface/game_over/game_over.tscn")

#endregion
