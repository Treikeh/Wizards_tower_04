extends CharacterBody3D

@export var camera_sens: float = 0.1
@export var max_speed: float = 6.0
@export var acceleration: float = 10.0
@export var jump_force: float = 5.0

@export_group("Nodes")
@export var orientaion: Node3D
@export var head: Node3D
@export var camera: Camera3D

var move_input: Vector2 = Vector2.ZERO
var move_direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate camera
		if event is InputEventMouseMotion:
			orientaion.rotate_object_local(Vector3.UP, -deg_to_rad(event.relative.x * camera_sens))
			head.rotate_object_local(Vector3.RIGHT, -deg_to_rad(event.relative.y * camera_sens))
			head.rotation.x = clampf(head.rotation.x, -deg_to_rad(89), deg_to_rad(89))
		
		if event.is_action_pressed("jump"):
			jump()
		
		move_input = Input.get_vector("move_l", "move_r", "move_f", "move_b")
		# Show mouse cursor when pressing esc

func _process(delta: float) -> void:
	move_direction = orientaion.basis * Vector3(move_input.x, 0.0, move_input.y).normalized()
	
	camera.apply_camera_tilt(velocity, move_direction, delta)
	if is_on_floor():
		camera.head_bobbing(velocity, delta)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity = lerp(velocity, move_direction * max_speed, acceleration * delta)
	else:
		velocity.y -= 9.8 * delta
	move_and_slide()

func jump() -> void:
	if is_on_floor():
		velocity.y = jump_force
