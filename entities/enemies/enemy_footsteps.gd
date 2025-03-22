extends AudioStreamPlayer3D


@export var frequency: float = 5.0
@export var sound_a: AudioStreamWAV
@export var sound_b: AudioStreamWAV

var is_left_step: bool = false
var time: float = 0.0


func _process(delta: float) -> void:
	time += delta
	var horizontal: float = cos(time * frequency * 0.5)
	if is_left_step:
		if horizontal > 0.02:
			stream = sound_a
			play(0.0)
			is_left_step = false
	else:
		if horizontal < -0.02:
			stream = sound_b
			play(0.0)
			is_left_step = true
