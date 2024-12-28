class_name Health
extends Node


## Emitted when health is changed. Usefull for updating other nodes like the UI or enemy behaviour
signal health_changed(current_health: float, max_health: float)
## Emitted when health <= 0.0 (Owner is dead).
signal health_depleted


@export var max_health: float = 100.0
## How many % to reduce or increase (if negative) incoming physical damage by. Will be healed if over 100.0
@export var physical_resistance: float = 0.0
## How many % to reduce or increase (if negative) incoming fire damage by. Will be healed if over 100.0
@export var fire_resisance: float = 0.0
var is_dead: bool = false
var current_health: float


func _ready() -> void:
	current_health = max_health


func take_damage(amount: float, type: Damage.DamageType) -> void:
	if is_dead:
		return
	var damage_taken: float = _apply_damage_resistance(amount, type)
	current_health -= damage_taken
	health_changed.emit(current_health, max_health)
	if current_health <= 0.0:
		health_depleted.emit()
		is_dead = true


func _apply_damage_resistance(amount: float, type: Damage.DamageType) -> float:
	match type:
		Damage.DamageType.PHYSICAL:
			return amount * _resistance_to_mult(physical_resistance)
		Damage.DamageType.FIRE:
			return amount * _resistance_to_mult(fire_resisance)
	return amount


func _resistance_to_mult(resistance: float) -> float:
	return 1.0 - (resistance / 100.0)
