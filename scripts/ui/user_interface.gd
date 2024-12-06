extends CanvasLayer
#TODO I want to make this scene a part of the main scene, but i'm not sure how i am going to ->
# <- hide and show the right "widget" after level loading

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func pause_game() -> void:
	#TODO I want to move pausing to "main.gd" since i feel like it should have that responsibility
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	%Hud.hide()
	%PauseMenu.show()

func resume_game() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	%Hud.show()
	%PauseMenu.hide()

func _on_main_menu_button_pressed() -> void:
	LevelManager.load_level("res://levels/main_menu.tscn")

func _on_quit_button_pressed() -> void:
	SignalHub.quit_game.emit()
