extends CharacterBody3D


## How fast the wall will move when hit by the wind blast spell
@export var wind_blast_force: float = 7.5
## How long it will take for the wall to explode when hit with the fireball spell (when stationary)
@export var explosion_delay: float = 3.0

var ready_to_explode: bool = false

@export_group("Nodes")
@export var enemy_launch_area: Area3D
@export var explosion_area: Area3D
## Timer to manage how long the spell will remain in the scene
@export var duration_timer: Timer
@export var animation_player: AnimationPlayer


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if is_on_wall() or !is_on_floor():
		velocity = Vector3.ZERO
	move_and_slide()


# Despawn or explode wall when timer is done
func _on_duration_timer_timeout() -> void:
	if ready_to_explode:
		_explode()
	else:
		_on_health_depleted()


func _launch_enemies()-> void:
	var overlapping_enemies: Array[Node3D] = enemy_launch_area.get_overlapping_bodies()
	for body in overlapping_enemies:
		if body is Enemy:
			body.recive_knockback(Vector3.UP, 7.5)


#TODO: Find a better way to do this
func recive_knockback(direction: Vector3) -> void:
	velocity = Vector3(direction.x, 0.0, direction.z).normalized() * wind_blast_force
	ready_to_explode = true
	# Add damage to movement


func _explode() -> void:
	explosion_area.trigger()
	_on_health_depleted()


#region Health

# When wall health is depleted
func _on_health_depleted() -> void:
	animation_player.play("destroyed")


func _on_health_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("fireball"):
		if ready_to_explode:
			_explode()
		else:
			ready_to_explode = true
			duration_timer.wait_time = explosion_delay
			duration_timer.start(0.0)

#endregion
