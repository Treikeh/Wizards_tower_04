extends Control


@export_file("*.tscn") var pause_menu_scene: String

var notification_duration: float = 3.0
var notification_timer: SceneTreeTimer


func _ready() -> void:
	# Connect signals
	Globals.interact_prompt_updated.connect(_on_interact_prompt_updated)
	Globals.health_bar_updated.connect(_on_health_bar_updated)
	Globals.player_casted_spell.connect(_on_player_casted_spell)
	Globals.spell_unlocked.connect(_on_spell_unlocked)
	Globals.notification_message_sent.connect(_on_notification_message_sent)
	
	# Set starting health
	#TODO: I need a system that saves player data across levels.
	%HealthBar.value = Globals.player_health
	%NotificationLabel.modulate = Color.TRANSPARENT
	
	# Set spell icon values
	await get_tree().process_frame
	%FireBallIcon.value = 0.0
	if Globals.fireball_unlocked:
		%FireBallIcon.value = 1.0
		
	%RockWallIcon.value = 0.0
	if Globals.rock_wall_unlocked:
		%RockWallIcon.value = 1.0
	
	%WindBlastIcon.value = 0.0
	if Globals.wind_blast_unlocked:
		%WindBlastIcon.value = 1.0


func _process(_delta: float) -> void:
	%FpsLabel.text = str(Engine.get_frames_per_second())
	
	# Pause game when pressing ESC
	if Input.is_action_just_pressed("ui_cancel"):
		hide()
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Spawn pause menu
		var pause_menu: Control = Globals.main_scene.add_ui_scene(pause_menu_scene)
		pause_menu.tree_exited.connect(_on_pause_menu_closed)


func _on_pause_menu_closed() -> void:
	show()


func _on_interact_prompt_updated(prompt: String) -> void:
	%InteractLabel.text = prompt


func _on_health_bar_updated(value: float) -> void:
	%HealthBar.value = value
	Globals.player_health = value


func _on_spell_unlocked(spell: String) -> void:
	match spell:
		"fireball":
			%FireBallIcon.value = 1.0
			_on_notification_message_sent("Fireball learned")
		"rock_wall":
			%RockWallIcon.value = 1.0
			_on_notification_message_sent("Rock wall learned")
		"wind_blast":
			%WindBlastIcon.value = 1.0
			_on_notification_message_sent("Wind blast leared")


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


func _on_notification_message_sent(message: String) -> void:
	%NotificationLabel.modulate = Color.WHITE
	%NotificationLabel.text = message
	notification_timer = get_tree().create_timer(notification_duration)
	await notification_timer.timeout
	var fade_tween: Tween = get_tree().create_tween()
	fade_tween.tween_property(%NotificationLabel, "modulate", Color.TRANSPARENT, 1.0)
