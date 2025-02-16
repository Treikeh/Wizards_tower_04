extends Control


@export_file("*.tscn") var pause_menu_scene: String

var notification_duration: float = 3.0
var notification_fade_tween: Tween


func _ready() -> void:
	# Connect signals
	Globals.interact_prompt_updated.connect(_on_interact_prompt_updated)
	Globals.health_bar_updated.connect(_on_health_bar_updated)
	Globals.spell_recharge_started.connect(_on_spell_recharge_started)
	Globals.spell_recharge_ended.connect(_on_spell_recharge_ended)
	Globals.player_casted_spell.connect(_on_player_casted_spell)
	Globals.spell_unlocked.connect(_on_spell_unlocked)
	Globals.notification_message_sent.connect(_on_notification_message_sent)
	
	%NotificationTimer.wait_time = notification_duration
	
	# Set starting health
	#TODO: I need a system that saves player data across levels.
	%HealthBar.value = %HealthBar.max_value
	%NotificationLabel.modulate = Color.TRANSPARENT
	
	# Set spell icon values
	await get_tree().process_frame
	%FireBallIcon.value = 0.0
	%FireballCastsLabel.text = ""
	if Globals.fireball_unlocked:
		%FireBallIcon.value = 1.0
		%FireballCastsLabel.text = "3"
		
	%RockWallIcon.value = 0.0
	%RockWallCastsLabel.text = ""
	if Globals.rock_wall_unlocked:
		%RockWallIcon.value = 1.0
		%RockWallCastsLabel.text = "2"
	
	%WindBlastIcon.value = 0.0
	%WindBlastCastsLabel.text = ""
	if Globals.wind_blast_unlocked:
		%WindBlastIcon.value = 1.0
		%WindBlastCastsLabel.text = "5"


func _process(_delta: float) -> void:
	%FpsLabel.text = str(Engine.get_frames_per_second())
	
	# Pause game when pressing ESC
	if Input.is_action_just_pressed("ui_cancel"):
		hide()
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Spawn pause menu
		var pause_menu: Control = UiManager.add_ui_scene(pause_menu_scene)
		pause_menu.tree_exited.connect(_on_pause_menu_closed)


func _on_pause_menu_closed() -> void:
	show()


func _on_interact_prompt_updated(prompt: String) -> void:
	%InteractLabel.text = prompt


func _on_health_bar_updated(value: float) -> void:
	%HealthBar.value = value


func _on_spell_unlocked(spell: int) -> void:
	match spell:
		0:
			%FireBallIcon.value = 1.0
			%FireballCastsLabel.text = "3"
			_on_notification_message_sent("Fireball learned")
		1:
			%RockWallIcon.value = 1.0
			%RockWallCastsLabel.text = "2"
			_on_notification_message_sent("Rock wall learned")
		2:
			%WindBlastIcon.value = 1.0
			%WindBlastCastsLabel.text = "5"
			_on_notification_message_sent("Wind blast leared")


func _on_player_casted_spell(id: int) -> void:
	match id:
		0: # Fireball
			var casts: int = int(%FireballCastsLabel.text)
			%FireballCastsLabel.text = str(casts - 1)
		1: # Rock wall
			var casts: int = int(%RockWallCastsLabel.text)
			%RockWallCastsLabel.text = str(casts - 1)
		2: # Wind blast
			var casts: int = int(%WindBlastCastsLabel.text)
			%WindBlastCastsLabel.text = str(casts - 1)


func _on_spell_recharge_started(spell: int, spell_cooldown: float) -> void:
	var color_tween: Tween = create_tween()
	match spell:
		0: # Fireball
			%FireBallIcon.value = 0.0
			color_tween.tween_property(%FireBallIcon, "value", 1.0, spell_cooldown)
		1: # Rock wall
			%RockWallIcon.value = 0.0
			color_tween.tween_property(%RockWallIcon, "value", 1.0, spell_cooldown)
		2: # Wind blast
			%WindBlastIcon.value = 0.0
			color_tween.tween_property(%WindBlastIcon, "value", 1.0, spell_cooldown)


func _on_spell_recharge_ended(spell: int) -> void:
	match spell:
		0: # Fireball
			var casts: int = int(%FireballCastsLabel.text)
			%FireballCastsLabel.text = str(casts + 1)
		1: # Rock wall
			var casts: int = int(%RockWallCastsLabel.text)
			%RockWallCastsLabel.text = str(casts + 1)
		2: # Wind blast
			var casts: int = int(%WindBlastCastsLabel.text)
			%WindBlastCastsLabel.text = str(casts + 1)


func _on_notification_message_sent(message: String) -> void:
	if notification_fade_tween:
		notification_fade_tween.stop()
	%NotificationLabel.modulate = Color.WHITE
	%NotificationLabel.text = message
	%NotificationTimer.start(0.0)
	await %NotificationTimer.timeout
	notification_fade_tween = create_tween()
	notification_fade_tween.tween_property(%NotificationLabel, "modulate", Color.TRANSPARENT, 1.0)
