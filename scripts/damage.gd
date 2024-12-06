extends Resource
class_name Damage

enum Type {
	PHYSICAL,
	FIRE,
}

@export var amount: float = 10
@export var type: Type
