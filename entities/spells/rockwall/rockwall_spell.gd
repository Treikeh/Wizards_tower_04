extends Spell


@export_group("Preview")
@export var preview: Marker3D
@export var preview_ray: RayCast3D
@export var preview_mesh: MeshInstance3D
@export var can_spawn_mat: StandardMaterial3D
@export var cannot_spawn_mat: StandardMaterial3D

var rockwall_scene: String = "uid://d2tj1vsg1g6a7"


func _ready() -> void:
	preview.hide()


func _physics_process(_delta: float) -> void:
	if preview.visible and is_colliding():
		# Set preview transform
		preview.global_position = get_collision_point()
		preview.global_rotation.y = global_rotation.y
		
		# Preview visuals
		preview_mesh.visible = true
		if preview_ray.is_colliding():
			preview_mesh.material_override = cannot_spawn_mat
		else:
			preview_mesh.material_override = can_spawn_mat
	else:
		preview_mesh.visible = false


func start_casting() -> void:
	if not can_cast_spell:
		return
	
	preview.show()


func stop_casting() -> void:
	if not preview_mesh.visible or preview_ray.is_colliding():
		return
	
	var rockwall: Node3D = load(rockwall_scene).instantiate()
	add_child(rockwall)
	rockwall.global_transform = preview.global_transform
	rockwall.top_level = true
	
	# Hide preview
	preview.hide()
	
	
	# Firerate
	can_cast_spell = false
	await get_tree().create_timer(fire_rate).timeout
	can_cast_spell = true
