class_name StateMachine
extends Node


@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	# Get all child states
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_changed.connect(_on_state_changed)
	
	# Set initial state
	if initial_state:
		initial_state._enter_state()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state._update_state(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_update_state(delta)


func _on_state_changed(state: State, new_state_name: String) -> void:
	# Make sure current state is sending signal
	if state != current_state:
		return
	
	# Chek if state exits and that it is a "State"
	var new_state = states.get(new_state_name.to_lower())
	if (not new_state) or (not new_state is State):
		return
	
	# Exit old state
	if current_state:
		current_state._exit_state()
	
	# Enter new state
	current_state = new_state
	current_state._enter_state()
