extends Node3D
## Makes this node match the y rotation of the target node


@export var speed: float = 5.0
@export var target_node: Node3D


func _process(delta: float) -> void:
	rotation.y = lerp_angle(rotation.y, target_node.rotation.y, speed * delta)
