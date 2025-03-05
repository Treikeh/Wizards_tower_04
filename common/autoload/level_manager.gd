extends Node3D


var level_to_load: String = ""


func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS


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
				LoadingScreen.update_progress(progress[0])
				return
			2: ## THREAD_LOAD_FAILED
				print("ERROR!: failed to load!")
				return
			3: ## THREAD_LOAD_LOADED
				# Add new level
				var new_scene: PackedScene = ResourceLoader.load_threaded_get(level_to_load)
				get_tree().change_scene_to_packed(new_scene)
				# Finish level loading
				level_to_load = ""
				# Hide loading screen
				LoadingScreen.transition_out()
				return


func change_level(level_path: String) -> void:
	# Check if level exists
	#NOTE: FileAccess.file_exists() doesn't work in a exported project
	if not ResourceLoader.exists(level_path):
		print("ERROR!: Level not found. Invalid path")
		return
	
	# Show loading screen
	LoadingScreen.transition_inn()
	await LoadingScreen.transition_finished
	
	# Start level loading
	level_to_load = level_path
	ResourceLoader.load_threaded_request(level_path)


func reload_level() -> void:
	LoadingScreen.fade_inn_out()
	await LoadingScreen.reload_finished
	get_tree().reload_current_scene()


func add_3d_scene(scene_path: String, spawn_position: Vector3 = Vector3.ZERO) -> Node3D:
	var scene: Node3D = load(scene_path).instantiate()
	get_tree().current_scene.add_child(scene)
	scene.global_position = spawn_position
	return scene
