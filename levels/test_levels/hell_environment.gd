extends WorldEnvironment


@export var sky_rotation_speed: float = 5.0
var time: float = 0.0


func _process(delta: float) -> void:
	time += delta
	var sin_wave: float = sin(time)
	environment.sky_rotation.x += sky_rotation_speed * delta * sin_wave
	environment.sky_rotation.y += sky_rotation_speed * delta * sin_wave
	environment.sky_rotation.z += sky_rotation_speed * delta * sin_wave
	environment.sky_custom_fov = sin_wave * 30.0
	
