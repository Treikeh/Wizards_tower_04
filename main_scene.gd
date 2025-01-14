class_name MainScene
extends Node


var level_to_load: String = ""

var curret_3d_level: Node3D
var current_2d_level: Node2D
var current_ui_scene: Control


func _ready() -> void:
	#Globals.main_scene = self
	
	# Set current levels and ui
	if %World3D.get_child_count() > 0:
		curret_3d_level = %World3D.get_child(0)
	
	if %World2D.get_child_count() > 0:
		curret_3d_level = %World3D.get_child(0)
	
	if %UserInterface.get_child_count() > 0:
		current_ui_scene = %UserInterface.get_child(0)
	
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
				%LoadingScreen.update_progress(progress[0])
				return
			2: ## THREAD_LOAD_FAILED
				print("ERROR!: failed to load!")
				return
			3: ## THREAD_LOAD_LOADED
				# Add new level
				var new_level = ResourceLoader.load_threaded_get(level_to_load).instantiate()
				%World3D.add_child.call_deferred(new_level)
				# Finish level loading
				level_to_load = ""
				curret_3d_level = new_level
				# Hide loading screen
				%LoadingScreen.transition_out()
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
	#FIXME: Always fails in build mode
	#if not FileAccess.file_exists(level_path):
	#	print("ERROR!: Level not found. Invalid path")
	#	return
	
	# Show loading screen
	%LoadingScreen.transition_inn()
	await %LoadingScreen.transition_finished
	
	#Unload previous level
	for child in %World3D.get_children():
		%World3D.remove_child(child)
		child.queue_free()
	# Give unload a frame to finish before doing anything else
	await get_tree().physics_frame
	
	# Start level loading
	level_to_load = level_path
	ResourceLoader.load_threaded_request(level_path)


func add_3d_scene(scene: Node3D) -> void:
	%World3D.add_child(scene)


func change_ui_scene(scene_path: String) -> void:
	# Check if scene exists
	#FIXME: Always fails in build mode
	#if not FileAccess.file_exists(scene_path):
	#	print("ERROR!: Ui scene not found. Invalid path")
	#	return
	
	# Remove old scene
	for child in %UserInterface.get_children():
		%UserInterface.remove_child(child)
		child.queue_free()
	
	# Add new scene
	var new_scene: Control = load(scene_path).instantiate()
	%UserInterface.add_child(new_scene)
	current_ui_scene = new_scene


func add_ui_scene(scene: Control) -> void:
	%UserInterface.add_child(scene)
