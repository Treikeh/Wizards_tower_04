extends Area3D
class_name InteractArea3D


signal interacted


@export var prompt: String = "Interact"


func interact() -> void:
	interacted.emit()
