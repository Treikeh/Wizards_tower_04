class_name SpellInfo
extends Resource


@export var firerate: float = 0.0
@export var recharge_duration: float = 1.0
@export var max_casts: int = 1

var remaning_casts: int


func _init() -> void:
	#NOTE: THIS IS STUPID
	_ready.call_deferred()


func _ready() -> void:
	remaning_casts = max_casts
