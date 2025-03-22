extends Node3D


@export var on_pressed: Dictionary[Node, StringName]


func _on_interacted() -> void:
	for node: Node in on_pressed:
		node.call(on_pressed[node])
