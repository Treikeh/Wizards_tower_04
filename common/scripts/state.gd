class_name State
extends Node
@warning_ignore_start("unused_parameter")
@warning_ignore_start("unused_signal")

signal completed


## Reference to state machine that is managing this state. Set by the state machine during _ready
var machine: StateMachine


## Called once on during _ready. Used to set up necessary references that only needs to be set once
func setup() -> void:
	pass


## Called every time the state becomes active. Can be used to initialize/reset the state
func enter() -> void:
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	pass


## Called every time a this state becomes inactive. Can be used to reset the state or clear soft
## references(those set during the enter function not setup) to save memory.
func exit() -> void:
	pass
