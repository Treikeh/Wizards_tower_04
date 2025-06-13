extends Node

signal looked(vector: Vector2)
signal moved(vector: Vector2)
signal jumped(pressed: bool)
signal interacted
signal primary_fired(pressed: bool)
signal secondary_fired(pressed: bool)


var _camera_sensitivity: float = 0.1


func _ready() -> void:
	# Capture mouse when game begins
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Load input config settings
	_load_input_settings()
	ConfigHandler.input_settings_changed.connect(_load_input_settings)


func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			var look_x: float = -deg_to_rad(event.relative.x * _camera_sensitivity)
			var look_y: float = -deg_to_rad(event.relative.y * _camera_sensitivity)
			looked.emit(Vector2(look_x, look_y))
		
		# jump input
		if event.is_action_pressed("jump"):
			jumped.emit(true)
		if event.is_action_released("jump"):
			jumped.emit(false)
		
		# Interact input
		if event.is_action_pressed("interact"):
			interacted.emit()
		
		# Spell inputs
		if event.is_action_pressed("primary_fire"):
			primary_fired.emit(true)
		elif event.is_action_released("primary_fire"):
			primary_fired.emit(false)
		
		if event.is_action_pressed("secondary_fire"):
			secondary_fired.emit(true)
		elif event.is_action_released("secondary_fire"):
			secondary_fired.emit(false)
		
		# Get move_input
		moved.emit(Input.get_vector("move_l", "move_r", "move_f", "move_b"))
	else:
		# Disable move input when mouse curosr is visible
		moved.emit(Vector2.ZERO)


func _load_input_settings() -> void:
	var input_settings: Dictionary = ConfigHandler.load_input_settings()
	_camera_sensitivity = input_settings.camera_sensitivity
