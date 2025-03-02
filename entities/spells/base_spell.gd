class_name Spell
extends RayCast3D


@export var fire_rate: float = 1.0
@export var duration: float = 10.0
@export var casting_animation: String = ""

var can_cast_spell: bool = true


func start_casting() -> void:
	pass


func stop_casting() -> void:
	pass
