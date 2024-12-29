class_name LoadingScreen
extends CanvasLayer


@export_group("Nodes")
@export var progress_bar: ProgressBar
@export var animation_player: AnimationPlayer


func _reset() -> void:
	progress_bar.value = 0.0


func update_progress(value: float) -> void:
	progress_bar.value = value
