extends Node

func _ready() -> void:
	SignalHub.load_level.connect(request_level_loading)
	SignalHub.quit_game.connect(on_quit_game)

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Progress level loading
	if level_to_load != "":
		load_level()


#region Level loading

@export_group("Level loading")
@export var loading_screen: LoadingScreen
@export var world_3d: Node3D
var level_to_load: String = ""
# Delay should be >= to the loading_screen "enter" animation length
var level_loading_delay: float = 1.0

func request_level_loading(path: String) -> void:
	# Check if level file exists
	if !FileAccess.file_exists(path):
		print("ERROR!: Level not found. Invalid path")
		return
	
	# Unpause game. Might not be necessary
	get_tree().paused = false
	
	# Start loading screen transition
	loading_screen.start_enter_transition()
	# Wait until the loading screen has fninshed its transition before unloading level
	await get_tree().create_timer(level_loading_delay).timeout
	
	# Unload level
	for child in world_3d.get_children():
		world_3d.remove_child(child)
		child.queue_free()
	
	# Request ResourceLoader to start loading new level
	level_to_load = path
	ResourceLoader.load_threaded_request.call_deferred(level_to_load, "", true)

func load_level() -> void:
	var progress: Array = []
	var status: int = ResourceLoader.load_threaded_get_status(level_to_load, progress)
	match status:
		0: # THREAD_LOAD_INVALID_RESOURCE
			print("ERROR!: invalid resource")
			return
		1: # THREAD_LOAD_IN_PROGRESS
			# Update loading progress bar
			# Could possibly be done inside the loading_screen scene
			loading_screen.update_progress(progress[0])
			return
		2: # THREAD_LOAD_FAILED
			print("ERROR!: failed to load!")
			return
		3: # THREAD_LOAD_LOADED
			finalize_level_loading()
			return

func finalize_level_loading() -> void:
	# Add new level to game
	var new_level = ResourceLoader.load_threaded_get(level_to_load).instantiate()
	world_3d.add_child.call_deferred(new_level)
	level_to_load = ""
	
	# Start loading screen exit transition
	loading_screen.start_exit_transition()

#endregion


#region System

func on_quit_game() -> void:
	get_tree().quit()

#endregion
