extends Node3D


@export var on_opened: Dictionary[Node, StringName]
@export var on_closed: Dictionary[Node, StringName]
@export var move_node: Node3D
@export var open_duration: float = 0.5
@export var close_duration: float = 0.5
@export var open_prompt: String = "Close"
@export var closed_prompt: String = "Open"
@export var open_position: Vector3
@export var open_rotation: Vector3 = Vector3(0.0, -90.0, 0.0)

@export_group(" ")
@export var interact_area: InteractArea3D

var is_open: bool = false


func _ready() -> void:
	interact_area.prompt = closed_prompt


func _on_interacted() -> void:
	if is_open:
		close()
	else:
		open()


func open() -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(move_node, "position", open_position, open_duration)
	tween.tween_property(move_node, "rotation_degrees", open_rotation, open_duration)
	await tween.finished
	is_open = true
	interact_area.prompt = open_prompt
	for node: Node in on_opened:
		node.call(on_opened[node])


func close() -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(move_node, "position", Vector3.ZERO, open_duration)
	tween.tween_property(move_node, "rotation_degrees", Vector3.ZERO, open_duration)
	await tween.finished
	is_open = false
	interact_area.prompt = closed_prompt
	for node: Node in on_closed:
		node.call(on_closed[node])
