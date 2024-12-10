extends CharacterBody3D

enum AiStates {
	PATROLING,
	CHASING,
}

@export_group("AI")
@export var nav_agent: NavigationAgent3D
var current_ai_state: AiStates = AiStates.PATROLING

@export_group("Movement")
@export var max_speed: float = 5.0
@export var acceleration: float = 10.0
var move_direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	update_target_position()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if !nav_agent.target_reached:
		move_direction = (global_position - nav_agent.get_next_path_position()).normalized()
	else:
		move_direction = Vector3.ZERO

#@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	velocity.x = lerpf(velocity.x, move_direction.x * max_speed, acceleration * delta)
	velocity.z = lerpf(velocity.z, move_direction.z * max_speed, acceleration * delta)
	if !is_on_floor():
		velocity.y -= 9.8 * delta
	move_and_slide()
	
func update_target_position() -> void:
	var new_position: Vector3 = get_random_position(global_position)
	nav_agent.set_target_position(new_position)

func get_random_position(vec: Vector3) -> Vector3:
	var x: float = randf_range(-10.0, 10.0)
	var y: float = randf_range(-10.0, 10.0)
	var z: float = randf_range(-10.0, 10.0)
	return Vector3(vec.x + x, vec.y + y, vec.z + z)

func change_ai_state() -> void:
	match current_ai_state:
		AiStates.PATROLING:
			%AiStateLabel.text = "Patroling"
		AiStates.CHASING:
			%AiStateLabel.text = "Chasing"

func _on_health_health_depleted() -> void:
	queue_free()
