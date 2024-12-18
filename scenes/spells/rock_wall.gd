extends Node3D

var lifetime: float = 10.0

func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(despawn_spell)

func despawn_spell() -> void:
	queue_free()
