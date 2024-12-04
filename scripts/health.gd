extends Node
class_name Health

signal health_depleted

@export var max_health: float = 100.0

var current_health: float

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	current_health -= amount
	if current_health <= 0.0:
		health_depleted.emit()
