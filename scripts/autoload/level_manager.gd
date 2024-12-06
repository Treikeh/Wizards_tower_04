extends Node

var level_path: String = ""
var level_root: Node

var loading_screen: CanvasLayer
var loading_screen_scene: Resource = preload("res://levels/loading_screen.tscn")

func _ready() -> void:
	# Spawn loading_screen, but keep it hidden unitl loading a level
	loading_screen = loading_screen_scene.instantiate()
	loading_screen.hide()
	get_tree().root.add_child.call_deferred(loading_screen)

func _process(_delta: float) -> void:
	if level_path != "":
		var progress: Array = []
		var status: int = ResourceLoader.load_threaded_get_status(level_path, progress)
		match status:
			0: # THREAD_LOAD_INVALID_RESOURCE
				print("error: invalid resource")
				return
			1: # THREAD_LOAD_IN_PROGRESS
				loading_screen.progress_bar.value = (progress[0])
			2: # THREAD_LOAD_FAILED
				print("error: failed to load!")
				return
			3: # THREAD_LOAD_LOADED
				# Add new level to game
				var new_level = ResourceLoader.load_threaded_get(level_path).instantiate()
				level_root.add_child.call_deferred(new_level)
				# Hide loading_screen when level has finished loading
				loading_screen.hide()
				# Clear level_path
				level_path = ""
				return

func load_level(path: String) -> void:
	# Check if level file exists
	if !FileAccess.file_exists(path):
		print("ERROR: Level not found. Invalid path")
		return
	
	get_tree().paused = false
	loading_screen.show()
	
	unload_level()
	level_path = path
	ResourceLoader.load_threaded_request(level_path, "", true)

func unload_level() -> void:
	for child in level_root.get_children():
		level_root.remove_child(child)
		child.queue_free()
