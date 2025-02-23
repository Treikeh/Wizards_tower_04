extends CanvasLayer


signal transition_finished
signal reload_finished


@export_group(" ")
@export var progress_bar: ProgressBar
@export var anim_player: AnimationPlayer


func _ready() -> void:
	hide()


func transition_inn() -> void:
	# Reset progress bar
	progress_bar.value = 0.0
	# Play transition animation
	anim_player.play("inn")
	await anim_player.animation_finished
	transition_finished.emit()


func transition_out() -> void:
	anim_player.play("out")
	await anim_player.animation_finished
	transition_finished.emit()


func fade_inn_out() -> void:
	anim_player.play("reload")

func reload_event() -> void:
	reload_finished.emit()


func update_progress(value: float) -> void:
	progress_bar.value = value
