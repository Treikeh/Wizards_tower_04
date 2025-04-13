extends ShapeCast3D
# ShapeCast is used to check if player should be checking for the ground.
# RayCast is used to calcualte wheter or not the player is actually on the ground.
# Only using ShapeCast3D worked well, but sometimes the player would become airborne when walking
# into slopes and triggering the "land" sound effect which was annoying. (I belive it's an issue
# with the ShapeCast hitting the corner of the slope at a weird angle)
# RayCast gave the best result, but the detection area was too narrow, so the player would often
# fall off high ledges even though it looked like they were still on the ground.
#NOTE: Set "Margin" to > 0.0 on ShapeCast3D. Percision is not needed (RayCast3D handles percision)
#NOTE: ShapeCast and RayCast needs to have the same collision masks


@export var max_slope_angle: float = 40.0
@export var leave_y_force: float = 5.0

@export_group("Spring force")
@export var rest_height: float = 1.0
#@export var ground_buffer: float = 0.5
@export var spring_force: float = 300.0
@export var spring_damping: float = 25.0

var is_grounded: bool = false
var ground_normal: Vector3 = Vector3.UP

@onready var player: RigidBody3D = owner
@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _physics_process(_delta: float) -> void:
	is_grounded = _is_on_walkable_slope()
	if is_grounded:
		_snap_to_ground()


func _is_on_walkable_slope() -> bool:
	# If too much force is applied upwards leave the ground
	if player.linear_velocity.y >= leave_y_force:
		return false
	# Check if floor is too steep to walk on
	# Is ShapeCast colliding?
	if is_colliding():
		# Move RayCast to ShapeCast collision point on the XZ plane (don't change height)
		var col_pos: Vector3 = get_collision_point(0)
		ray_cast_3d.global_position.x = col_pos.x
		ray_cast_3d.global_position.z = col_pos.z
		ground_normal = ray_cast_3d.get_collision_normal()
		# Compare ground normal to upwards direction to get the slope angle
		if ground_normal.angle_to(Vector3.UP) < deg_to_rad(max_slope_angle):
			return true
		return false
	return false


#NOTE: I feel there should be a need for delta, but i don't know where :\
# Apply a spring force that moves the palyer towards "rest_height"
func _snap_to_ground() -> void:
	var hit_distance: float = (global_position - ray_cast_3d.get_collision_point()).length()
	var normal_vel: float = -ground_normal.dot(player.linear_velocity)
	var dispalcement: float = hit_distance - rest_height
	var force: float = (spring_force * dispalcement) - (normal_vel * spring_damping)
	player.apply_central_force(Vector3.DOWN * force * player.mass)
