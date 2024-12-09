extends Camera3D

#region Head bobbing

@export_group("Head bobbing")
@export var hb_frequency: float = 2.5
@export var hb_amplitude: float = 0.025
var hb_time: float = 0.0

func head_bobbing(velocity: Vector3, delta: float) -> void:
	hb_time += delta * velocity.length()
	var horizonal: float = cos(hb_time * hb_frequency * 0.5) * hb_amplitude
	var vertical: float = sin(hb_time * hb_frequency) * hb_amplitude
	transform.origin = Vector3(horizonal, vertical, 0.0)

#endregion


#region Camera tilt

# It's not happening anymore... Why? And what changed?
# TODO-FIXME: When moving from 1 dir to the oppisite dir the camera tilt twitches.
@export_group("Camera tilt")
@export var max_tilt: float = 5.0
@export var tilt_speed: float = 1.0

func apply_camera_tilt(velocity: Vector3, input: Vector3, delta: float) -> void:
	var dir_dot: float = 0
	if input:
		dir_dot = global_basis.x.dot(velocity.normalized())
	rotation.z = lerp_angle(rotation.z, -deg_to_rad(max_tilt) * dir_dot, tilt_speed * delta)

#endregion
