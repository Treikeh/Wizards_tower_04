class_name Enemy
extends CharacterBody3D


@export_group("Movement")
@export var move_speed: float = 5.0
@export var acceleration: float = 10.0
var gravity_force: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var move_dir: Vector3

var receiving_knockback: bool = false
var knockback_duration: float = 0.5

@export_group("AI")
@export var nav_agent: NavigationAgent3D
@export var beehave_tree: BeehaveTree


func _physics_process(delta: float) -> void:
	if not nav_agent.is_target_reached():
		move_dir = (nav_agent.get_next_path_position() - global_position).normalized()
	
	# Update velocity
	if not receiving_knockback:
		velocity.x = lerp(velocity.x, move_dir.x * move_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, move_dir.z * move_speed, acceleration * delta)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity_force * delta
	
	move_and_slide()


#TODO: Make knockback NOT time based
func recive_knockback(direction: Vector3, force: float = 10.0) -> void:
	receiving_knockback = true
	velocity = direction * force
	await get_tree().create_timer(knockback_duration).timeout
	receiving_knockback = false
