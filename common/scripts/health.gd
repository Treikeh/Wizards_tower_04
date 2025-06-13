@icon("res://common/icons/health.svg")
class_name Health
extends Node


signal damage_taken(amount: float, type: Damage.Type)
signal changed(current: float, max: float)
signal depleted


@export var max_health: float = 100.0
@export var physical_resistance: float = 1.0
@export var fire_resistance: float = 1.0
@export var explosion_resistance: float = 1.0
@export var electrical_resistance: float = 1.0
@export var healing_resistance: float = -1.0

@onready var current_health: float = max_health


func take_damage(amount: float, type: Damage.Type) -> void:
	if current_health <= 0.0:
		return
	
	# Multiply damage amount by damage type
	amount *= _get_damage_resistances(type)
	damage_taken.emit(amount, type)
	
	current_health -= amount
	changed.emit(current_health, max_health)
	
	# Stop current health from being greater than max_health
	if current_health > max_health:
		current_health = max_health
	elif current_health <= 0.0:
		depleted.emit()


func _get_damage_resistances(type: Damage.Type) -> float:
	match type:
		Damage.Type.PHYSICAL:
			return physical_resistance
		Damage.Type.FIRE:
			return fire_resistance
		Damage.Type.EXPLOSIVE:
			return explosion_resistance
		Damage.Type.ELECTRICAL:
			return electrical_resistance
		Damage.Type.HEALING:
			return healing_resistance
	return 1.0
