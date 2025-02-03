extends Node3D


@export var open_duration: float = 0.5
@export var close_duration: float = 0.5
@export var open_position: Vector3
@export var open_rotation: Vector3 = Vector3(0.0, -90.0, 0.0)

@export_group("Nodes")
@export var door_body: StaticBody3D
@export var interact_area: InteractArea3D

var is_open: bool = false


func _on_interact_area_3d_interacted() -> void:
	if is_open:
		var tween: Tween = create_tween().set_parallel(true)
		tween.tween_property(door_body, "position", Vector3.ZERO, open_duration)
		tween.tween_property(door_body, "rotation_degrees", Vector3.ZERO, open_duration)
		await tween.finished
		is_open = false
		interact_area.prompt = "Open"
	else:
		var tween: Tween = create_tween().set_parallel(true)
		tween.tween_property(door_body, "position", open_position, open_duration)
		tween.tween_property(door_body, "rotation_degrees", open_rotation, open_duration)
		await tween.finished
		is_open = true
		interact_area.prompt = "Close"
