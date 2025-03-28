extends ShapeCast3D


@export var max_slope_angle: float = 40.0
@export var leave_y_force: float = 5.0

@export_group("Spring force")
@export var rest_height: float = 1.0
@export var ground_buffer: float = 0.5
@export var spring_force: float = 300.0
@export var spring_damping: float = 25.0

var is_grounded: bool = false
var ground_normal: Vector3 = Vector3.UP

@onready var player: RigidBody3D = owner


func _physics_process(_delta: float) -> void:
	is_grounded = _is_on_walkable_slope()
	if is_grounded:
		_snap_to_ground()


func _is_on_walkable_slope() -> bool:
	# If too much force is applied upwards leave the ground
	if player.linear_velocity.y >= leave_y_force:
		return false
	# Check if floor is too steep to walk on
	if is_colliding():
		ground_normal = get_collision_normal(0)
		# Compare ground normal to upwards direction to get slope angle
		if ground_normal.angle_to(Vector3.UP) < deg_to_rad(max_slope_angle):
			return true
		return false
	return false


# I feel there should be a need for delta, but i do not know where :\
# Apply a spring force to that moves the palyer towards rest_height
func _snap_to_ground() -> void:
	var hit_distance: float = (global_position - get_collision_point(0)).length()
	var normal_vel: float = -ground_normal.dot(player.linear_velocity)
	var dispalcement: float = hit_distance - rest_height
	var force: float = (spring_force * dispalcement) - (normal_vel * spring_damping)
	player.apply_central_force(Vector3.DOWN * force * player.mass)
