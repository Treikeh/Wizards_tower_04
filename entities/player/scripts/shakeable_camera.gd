extends Area3D


@export var reduction_rate: float = 0.5
var shake: float = 0.0

@export var max_x: float = 25.0
@export var max_y: float = 25.0
@export var max_z: float = 12.5

@export_group("Noise")
@export var noise: FastNoiseLite
@export var noise_speed: float = 50.0

var time: float = 0.0


func _process(delta: float) -> void:
	time += delta
	shake = maxf(shake - delta * reduction_rate, 0.0)
	
	#TODO: Scale noise speed based on shake intensity
	
	rotation_degrees.x = 0.0 + max_x * _get_shake_intensity() * _get_noise_from_seed(0)
	rotation_degrees.y = 0.0 + max_y * _get_shake_intensity() * _get_noise_from_seed(1)
	rotation_degrees.z = 0.0 + max_z * _get_shake_intensity() * _get_noise_from_seed(2)


func add_camera_shake(shake_amount: float) -> void:
	shake = clampf(shake + shake_amount, 0.0, 1.0)


func _get_shake_intensity() -> float:
	return shake * shake


func _get_noise_from_seed(seed_: int) -> float:
	noise.seed = seed_
	return noise.get_noise_1d(time * noise_speed)
