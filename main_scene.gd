class_name MainScene
extends Node


@export var world_3d: Node3D
@export var world_2d: Node2D
@export var user_interface: Control
@export var loading_screen: LoadingScreen

var level_to_load: String = ""

var curret_3d_level: Node3D
var current_2d_level: Node2D
var current_ui_scene: Control


func _ready() -> void:
	# Set current levels and ui scenes
	if world_3d.get_child_count() > 0:
		curret_3d_level = world_3d.get_child(0)
	
	if world_2d.get_child_count() > 0:
		curret_3d_level = world_2d.get_child(0)
	
	if user_interface.get_child_count() > 0:
		current_ui_scene = user_interface.get_child(0)
	
	# Load video settings when game starts and when they are changed
	ConfigHandler.video_settings_changed.connect(_load_video_settings)
	_load_video_settings()


func _process(_delta: float) -> void:
	if level_to_load != "":
		var progress: Array = []
		var status: int = ResourceLoader.load_threaded_get_status(level_to_load, progress)
		match status:
			0: ## THREAD_LOAD_INVALID_RESOURCE
				print("ERROR!: invalid resource")
				return
			1: ## THREAD_LOAD_IN_PROGRESS
				# Update loading progress bar
				# Could possibly be done inside the loading_screen scene
				loading_screen.update_progress(progress[0])
				return
			2: ## THREAD_LOAD_FAILED
				print("ERROR!: failed to load!")
				return
			3: ## THREAD_LOAD_LOADED
				# Add new level
				var new_level = ResourceLoader.load_threaded_get(level_to_load).instantiate()
				world_3d.add_child.call_deferred(new_level)
				# Finish level loading
				level_to_load = ""
				curret_3d_level = new_level
				# Hide loading screen
				loading_screen.transition_out()
				return


func _load_video_settings() -> void:
	# Load video settings from config when game starts
	var video_settings: Dictionary = ConfigHandler.load_video_settings()
	if video_settings.is_empty():
		return
	
	# Set display mode
	match video_settings.display_mode:
		"FULLSCREEN":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		"BORDERLESS_FULLSCREEN":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		"WINDOWED":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		"BORDERLESS_WINDOWED":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	
	# Set resolution when game starts
	var resolution: String = str(video_settings.resolution)
	match resolution:
		"(720, 480)":
			DisplayServer.window_set_size(Vector2i(720, 480))
		"(960, 540)":
			DisplayServer.window_set_size(Vector2i(960, 540))
		"(1920, 1080)":
			DisplayServer.window_set_size(Vector2i(1920, 1080))
	
	#TODO: Center window after loading video settings


func quit_game() -> void:
	# Add saving here if needed
	get_tree().quit()


func change_3d_level(level_path: String) -> void:
	# Check if level exists
	#NOTE: FileAccess.file_exists() doesn't work in a exported project
	if not ResourceLoader.exists(level_path):
		print("ERROR!: Level not found. Invalid path")
		return
	
	# Show loading screen
	loading_screen.transition_inn()
	await loading_screen.transition_finished
	
	#Unload previous level
	for child in world_3d.get_children():
		world_3d.remove_child(child)
		child.queue_free()
	# Give unload a frame to finish before doing anything else
	await get_tree().physics_frame
	
	# Start level loading
	level_to_load = level_path
	ResourceLoader.load_threaded_request(level_path)


func add_3d_scene(scene: Node3D) -> void:
	world_3d.add_child(scene)


func change_ui_scene(scene_path: String) -> void:
	# Check if scene exists
	#NOTE: FileAccess.file_exists() doesn't work in a exported project
	if not ResourceLoader.exists(scene_path):
		print("ERROR!: Ui scene not found. Invalid path")
		return
	
	# Remove old scene
	for child in user_interface.get_children():
		user_interface.remove_child(child)
		child.queue_free()
	
	# Add new scene
	var new_scene: Control = load(scene_path).instantiate()
	user_interface.add_child(new_scene)
	current_ui_scene = new_scene


# Should only be used when a new ui scene is needed, but you still want to keep the old one active
func add_ui_scene(scene_path: String) -> Control:
	var scene: Control = load(scene_path).instantiate()
	user_interface.add_child(scene)
	return scene
