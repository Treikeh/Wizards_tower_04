extends Area3D

@onready var arrow: Node3D = $Arrow

func _ready() -> void:
	arrow.hide()
	if !gravity_point:
		gravity_direction = -arrow.global_basis.y
	else:
		gravity_direction = Vector3.ZERO
