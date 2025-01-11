extends AnimationTree


@export var character: Enemy


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if character.velocity.length_squared() > 1.0:
		set("parameters/conditions/idle", false)
		set("parameters/conditions/walking", true)
	else:
		set("parameters/conditions/idle", true)
		set("parameters/conditions/walking", false)
