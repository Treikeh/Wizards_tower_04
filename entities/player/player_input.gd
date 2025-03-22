extends Node


var move_input: Vector2


func _unhandled_input(event: InputEvent) -> void:
	move_input = Input.get_vector("move_l", "move_r", "move_f", "move_b")
