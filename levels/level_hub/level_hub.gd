extends Node3D


@export_file("*.tscn") var spell_select_menu_scene: String


func _ready() -> void:
	Globals.reset_run_info()
	Globals.run_started.connect(_on_run_started)


func _on_play_trigger_entered() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	UiManager.add_ui_scene(spell_select_menu_scene)


func _on_run_started() -> void:
	Globals.load_random_level()
