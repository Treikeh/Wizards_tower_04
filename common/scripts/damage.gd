class_name Damage
extends Resource


enum Type {
	PHYSICAL,
	FIRE,
	EXPLOSIVE,
	ELECTRICAL,
	HEALING,
}

@export var amount: float
@export var type: Type
