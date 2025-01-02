extends State


@export var character: Enemy
@export var target_range: float = 10.0


func _enter_state() -> void:
	print(character.name + " is chasing")


func _exit_state() -> void:
	print(character.name + " is no longer chasing")


func _update_state(delta: float) -> void:
	var player: RigidBody3D = get_tree().get_first_node_in_group("player")
	if character.global_position.distance_to(player.global_position) > target_range:
		state_changed.emit(self, "idle")
