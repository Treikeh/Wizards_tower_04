extends Node3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Load credits
	UiManager.change_ui_scene("uid://canvbdx7r3hfb")
	
	await get_tree().physics_frame
	UiManager.current_ui_scene.tree_exited.connect(_load_main_menu)


func _load_main_menu() -> void:
	LevelManager.change_level("uid://df823edaivqws")
