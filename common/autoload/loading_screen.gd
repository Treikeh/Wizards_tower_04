extends CanvasLayer


signal transition_finished


func _ready() -> void:
	hide()


func transition_inn() -> void:
	# Reset progress bar
	%ProgressBar.value = 0.0
	# Play transition animation
	%AnimationPlayer.play("inn")
	await %AnimationPlayer.animation_finished
	transition_finished.emit()


func transition_out() -> void:
	%AnimationPlayer.play("out")
	await %AnimationPlayer.animation_finished
	transition_finished.emit()


func update_progress(value: float) -> void:
	%ProgressBar.value = value
