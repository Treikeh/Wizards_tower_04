extends Control


func _ready() -> void:
	# Connect signals
	Globals.interact_prompt_updated.connect(_on_interact_prompt_updated)
	Globals.health_bar_updated.connect(_on_health_bar_updated)
	Globals.player_casted_spell.connect(_on_player_casted_spell)
	
	# Set starting health
	#TODO: I need a system that saves player data across levels.
	%HealthBar.value = Globals.player_health
	%FireBallIcon.value = 1.0
	%RockWallIcon.value = 1.0
	%WindBlastIcon.value = 1.0


func _input(event: InputEvent) -> void:
	# Spawn pause menu when pressing ESC
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Globals.main_scene.change_ui_scene("res://scenes/interface/pause_menu/pause_menu.tscn")


func _process(_delta: float) -> void:
	%FpsLabel.text = str(Engine.get_frames_per_second())


func _on_interact_prompt_updated(prompt: String) -> void:
	%InteractLabel.text = prompt


func _on_health_bar_updated(value: float) -> void:
	%HealthBar.value = value
	Globals.player_health = value


func _on_player_casted_spell(id: int, spell_cooldown: float) -> void:
	var color_tween: Tween = get_tree().create_tween()
	match id:
		0: # Fireball
			%FireBallIcon.value = 0.0
			color_tween.tween_property(%FireBallIcon, "value", 1.0, spell_cooldown)
		1: # Rock wall
			%RockWallIcon.value = 0.0
			color_tween.tween_property(%RockWallIcon, "value", 1.0, spell_cooldown)
		2: # Wind blast
			%WindBlastIcon.value = 0.0
			color_tween.tween_property(%WindBlastIcon, "value", 1.0, spell_cooldown)
