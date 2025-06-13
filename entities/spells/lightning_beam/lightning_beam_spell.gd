extends Spell


@export var damage: Damage

@export_group(" ")
@export var visuals: Marker3D


func _ready() -> void:
	visuals.hide()


func _process(delta: float) -> void:
	if is_colliding():
		# Deal damage
		var collider: Object = get_collider()
		if collider is HealthArea3D:
			collider.recive_damage(damage.amount * delta, damage.type)
		
		visuals.look_at(get_collision_point())
	else:
		visuals.look_at(to_global(target_position))


func start_casting() -> void:
	enabled = true
	visuals.show()
	$AudioStreamPlayer.play(0.0)


func stop_casting() -> void:
	enabled = false
	visuals.hide()
	$AudioStreamPlayer.stop()
