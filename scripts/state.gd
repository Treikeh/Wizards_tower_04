class_name State
extends Node


@warning_ignore("unused_signal")
signal state_changed(state: State, new_state_name: String)


func _enter_state() -> void:
	pass


@warning_ignore("unused_parameter")
func _update_state(delta: float) -> void:
	pass


@warning_ignore("unused_parameter")
func _physics_update_state(delta: float) -> void:
	pass


func _exit_state() -> void:
	pass
