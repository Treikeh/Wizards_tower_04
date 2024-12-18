extends CanvasLayer
class_name LoadingScreen

@export_group("Nodes")
@export var progress_bar: ProgressBar
@export var animation_player: AnimationPlayer

func start_enter_transition() -> void:
	animation_player.play("enter")
	# Reset loading screen when the enter transition starts
	progress_bar.value = 0.0
	show()

func enter_transition_finished() -> void:
	pass


func start_exit_transition() -> void:
	animation_player.play("exit")

func exit_transition_finished() -> void:
	hide()
