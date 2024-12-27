extends Enemy

@export_group("AI")
@export var chase_range: float = 10.0
@export var attack_range: float = 2.0
@export var attack_damage: Damage
var current_state: String = "idle"
var can_attack: bool = true
var player: Node3D

@export_group("Movement")
@export var max_speed: float = 3.0
@export var acceleration: float = 10.0

@export_group("Nodes")
@export var mesh: Node3D
@export var attack_ray: RayCast3D
@export var animation_player: AnimationPlayer

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	%AiStateLabel.text = current_state
	if velocity != Vector3.ZERO and current_state != "dead":
		mesh.look_at(mesh.global_position + Vector3(velocity.x, 0.0, velocity.z))

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if receiving_knockback:
		move_and_slide()
		return
	match current_state:
		"idle":
			idle(delta)
		"chase":
			chase(delta)
		"attack":
			attack(delta)
		"dead":
			pass


#region Health

func _on_health_depleted() -> void:
	current_state = "dead"
	animation_player.play("died")

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
	if !can_attack:
		return
	can_attack = false
	await get_tree().create_timer(0.75).timeout
	# Simple test attack
	if attack_ray.is_colliding():
		var collider: Object = attack_ray.get_collider()
		if collider is Hitbox:
			collider.recive_damage(attack_damage)
			print("Attack")
	if current_state != "dead":
		current_state = "idle"
		can_attack = true

#endregion
