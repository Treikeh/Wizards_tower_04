extends CharacterBody3D

@export_group("AI")
@export var chase_range: float = 10.0
@export var attack_range: float = 2.0
@export var nav_agent: NavigationAgent3D
var current_state: String = "idle"
var player: Node3D

@export_group("Movement")
@export var max_speed: float = 3.0
@export var acceleration: float = 10.0

@export_group("Nodes")
@export var mesh: Node3D

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	%AiStateLabel.text = current_state
	if velocity != Vector3.ZERO:
		mesh.look_at(mesh.global_position + velocity)

#@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	match current_state:
		"idle":
			idle(delta)
		"chase":
			chase(delta)
		"attack":
			attack(delta)

#region Health

func _on_health_depleted() -> void:
	queue_free()

#endregion

#region AI states

func idle(_delta: float) -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		var distance: float = (player.position - position).length()
		if distance < chase_range:
			current_state = "chase"

func chase(_delta: float) -> void:
	velocity = (nav_agent.get_next_path_position() - position).normalized() * max_speed
	nav_agent.target_position = player.position
	move_and_slide()
	var distance = (player.position - position).length()
	if distance < attack_range:
		current_state = "attack"
	elif distance > chase_range:
		current_state = "idle"

func attack(_delta: float) -> void:
	print("Attack")
	await get_tree().create_timer(1.0).timeout
	current_state = "idle"

#endregion
