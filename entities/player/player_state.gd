class_name PlayerState
extends State


var player: RigidBody3D


func setup() -> void:
	# Get reference to player from state machines blackboard
	player = machine.get_value("player")
