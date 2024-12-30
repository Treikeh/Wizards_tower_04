class_name MainScene
extends Node


@export_group("Nodes")
@export var world_3d: Node3D
@export var world_2d: Node2D
@export var user_interface: Control
@export var loading_screen: LoadingScreen

var level_to_load: String = ""

var curret_3d_level: Node3D
var current_2d_level: Node2D
var current_ui_scene: Control


func _ready() -> void:
	Globals.main_scene = self
	current_ui_scene = user_interface.get_child(0)


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
				loading_screen.animation_player.play("hide")
				return


func quit_game() -> void:
	# Add saving here if needed
	get_tree().quit()


func change_ui_scene(scene_path: String) -> void:
	# Check if scene exists
	if not FileAccess.file_exists(scene_path):
		print("ERROR!: Level not found. Invalid path")
		return
	
	# Remove old scene
	for child in user_interface.get_children():
		user_interface.remove_child(child)
		child.queue_free()
	
	# Add new scene
	var new_scene: Control = load(scene_path).instantiate()
	user_interface.add_child(new_scene)
	current_ui_scene = new_scene


func change_3d_level(level_path: String) -> void:
	# Check if level exists
	if not FileAccess.file_exists(level_path):
		print("ERROR!: Level not found. Invalid path")
		return
	
	# Show loading screen
	loading_screen.animation_player.play("show")
	await loading_screen.animation_player.animation_finished
	
	#Unload previous level
	for child in world_3d.get_children():
		world_3d.remove_child(child)
		child.queue_free()
	# Give unload a frame to finish before doing anything else
	await get_tree().physics_frame
	
	# Start level loading
	level_to_load = level_path
	ResourceLoader.load_threaded_request(level_path)
