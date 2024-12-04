extends Control

func _process(_delta: float) -> void:
	%FpsLabel.text = str(Engine.get_frames_per_second())
