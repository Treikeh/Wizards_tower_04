class_name Damage
extends Resource


enum Type {
	PHYSICAL,
	FIRE,
	HEALING,
}

@export var amount: float = 10
@export var type: Type = Type.PHYSICAL
