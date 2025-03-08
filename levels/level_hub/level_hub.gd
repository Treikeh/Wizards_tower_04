extends Node3D


func _ready() -> void:
	Globals.reset_run_info()


func _on_play_trigger_entered() -> void:
	Globals.load_random_level()
	Globals.start_run()
