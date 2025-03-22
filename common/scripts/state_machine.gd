class_name StateMachine
extends Node


signal state_completed
signal entered_state(state: State)


@export var init_state: State

var current_state: State
## Stores all states the state machine has acces to
var states: Dictionary[String, State]
## Stores values that states can use without having to reference other nodes directly
var _blackboard: Dictionary[String, Variant]


func _ready() -> void:
	# Check if init state exists. If not push a warning since the machine won't work without one
	if not init_state:
		push_warning("No initial state assigned in " + owner.name)
		return
	
	# Wait until owner is ready before entering the first state. This it to allow the owner to set
	# up the blackboard with all the necessary values.
	await owner.ready
	
	# Get all children and add them to states if they're a State
	for child: Node in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.machine = self
			child.setup()
			child.completed.connect(_on_state_completed)
	
	# Enter first state
	current_state = init_state
	current_state.enter()


func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func change_state(new_state_name: String) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	if not new_state:
		# If state doesn't exist stop function here
		return
	
	# There's no need to exit and enter the new state if it's the same as the current state
	if current_state == new_state:
		return
	
	# Transition to new state
	current_state.exit()
	current_state = new_state
	new_state.enter()
	# Emit signal that a new state has been entered
	entered_state.emit(new_state)


#TODO: Find a better way to check when a state is complete
#NOTE: This works, but i don't like this kind of "daisy chaining" of signals.
# I want to send a signal from the current_state up to the owner of the state machine and request it
# to choose a new state. This makes the owner responsible for deciding how to transition to new
# states and not the individual states or the state machine. The reason why i'm doing it this way
# is to avoid having states "know" about / being dependent on other states to function.
# A walking state shouldn't know or be dependet on there being a falling state to transition out of it
func _on_state_completed() -> void:
	state_completed.emit()


## Stores a value onto the blackboard
func set_value(key: String, value: Variant) -> void:
	_blackboard[key] = value


## Gets a value from the blackboard
func get_value(key: String) -> Variant:
	return _blackboard[key]
