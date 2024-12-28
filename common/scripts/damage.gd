class_name Damage
extends Resource


enum DamageType {
	PHYSICAL,
	FIRE,
}

@export var amount: float = 10
@export var type: DamageType = DamageType.PHYSICAL
