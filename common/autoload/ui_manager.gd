extends Control


var current_ui_scene: Control


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT, true)
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS


func change_ui_scene(scene_path: String) -> void:
	# Check if scene exists
	#NOTE: FileAccess.file_exists() doesn't work in a exported project
	if not ResourceLoader.exists(scene_path):
		print("ERROR!: Ui scene not found. Invalid path")
		return
	
	# Remove old scene
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	# Add new scene
	var new_scene: Control = load(scene_path).instantiate()
	add_child(new_scene)
	current_ui_scene = new_scene


# Should only be used when a new ui scene is needed, but you still want to keep the old one active
func add_ui_scene(scene_path: String) -> Control:
	var scene: Control = load(scene_path).instantiate()
	add_child(scene)
	return scene
