extends Node3D


@export var levels: Array[String] = []

var spell_select_menu_scene: String = "uid://dh8msa1h40vqf"


func _on_play_trigger_entered() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var spell_menu: Control = UiManager.add_ui_scene(spell_select_menu_scene)
	spell_menu.tree_exiting.connect(_start_run)


func _start_run() -> void:
	var level_index: int = randi_range(0, levels.size() - 1)
	LevelManager.change_level(levels[level_index])
