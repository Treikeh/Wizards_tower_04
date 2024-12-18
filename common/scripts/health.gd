extends Node
class_name Health

signal health_depleted
signal health_changed(current_health: float, max_health: float)

@export var max_health: float = 100.0
@export var physical_resistance: float = 0.0
@export var fire_resisance: float = 0.0
var is_dead: bool = false
var current_health: float

func _ready() -> void:
	current_health = max_health

func take_damage(damage: Damage) -> void:
	if is_dead:
		return
	var damage_taken: float = apply_damage_resistance(damage)
	current_health -= damage_taken
	health_changed.emit(current_health, max_health)
	if current_health <= 0.0:
		health_depleted.emit()
		is_dead = true

func apply_damage_resistance(damage: Damage) -> float:
	match damage.type:
		Damage.Type.PHYSICAL:
			return damage.amount * resistance_to_mult(physical_resistance)
		Damage.Type.FIRE:
			return damage.amount * resistance_to_mult(fire_resisance)
	return damage.amount

func resistance_to_mult(resistance: float) -> float:
	return 1.0 - (resistance / 100.0)
