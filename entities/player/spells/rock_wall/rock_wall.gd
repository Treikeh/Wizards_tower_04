extends CharacterBody3D


## How fast the wall will move when hit by the wind blast spell
@export var wind_blast_force: float = 7.5

@export_group(" ")
@export var enemy_launch_area: Area3D
@export var explosion_cast: ShapeCast3D
@export var camera_shake_source: CameraShakeSource
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
	_on_health_depleted()


func _launch_enemies()-> void:
	var overlapping_enemies: Array[Node3D] = enemy_launch_area.get_overlapping_bodies()
	for body in overlapping_enemies:
		if body is Enemy:
			body.recive_knockback(Vector3.UP, 7.5)


#TODO: Find a better way to do this
func recive_knockback(direction: Vector3) -> void:
	velocity = Vector3(direction.x, 0.0, direction.z).normalized() * wind_blast_force


func _explode() -> void:
	explosion_cast.trigger()
	camera_shake_source.shake_camera()
	_on_health_depleted()


#region Health

# When wall health is depleted
func _on_health_depleted() -> void:
	animation_player.play("destroyed")


func _on_health_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("fireball"):
		body.queue_free()
		_explode()

#endregion
