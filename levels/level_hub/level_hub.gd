extends Node3D


func _ready() -> void:
	Globals.reset_run_info()


func start_run() -> void:
	_on_play_trigger_entered()

func _on_play_trigger_entered() -> void:
	Globals.load_next_level()
	Globals.start_run()
