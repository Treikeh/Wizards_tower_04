extends Node3D


@export_group(" ")
@export var ground_snap_ray: RayCast3D
@export var camera_shake_source: CameraShakeSource
@export var anim_player: AnimationPlayer


func snap_to_ground() -> void:
	if ground_snap_ray.is_colliding():
		global_position = ground_snap_ray.get_collision_point()


func _on_strike_delay_timeout() -> void:
	anim_player.play("strike")
	camera_shake_source.shake_camera()
