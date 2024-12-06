extends Node
class_name Health

signal health_depleted
signal health_changed(current: float, max: float)

@export var max_health: float = 100.0

var current_health: float

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	current_health -= amount
	health_changed.emit(current_health, max_health)
	if current_health <= 0.0:
		health_depleted.emit()
