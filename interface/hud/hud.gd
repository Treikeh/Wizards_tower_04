extends Control


@export_file("*.tscn") var pause_menu_scene: String
@export var fireball_info: SpellInfo
@export var rock_wall_info: SpellInfo
@export var wind_blast_info: SpellInfo

var notification_duration: float = 3.0
var notification_fade_tween: Tween


func _ready() -> void:
	# Connect signals
	Globals.interact_prompt_updated.connect(_on_interact_prompt_updated)
	Globals.health_bar_updated.connect(_on_health_bar_updated)
	Globals.spell_casts_updated.connect(_on_spell_casts_updated)
	Globals.spell_recharge_started.connect(_on_spell_recharge_started)
	Globals.spell_unlocked.connect(_on_spell_unlocked)
	Globals.update_lightning_ray_icon.connect(_on_update_lightning_ray_icon)
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
		%FireballCastsLabel.text = str(fireball_info.max_casts)
		
	%RockWallIcon.value = 0.0
	%RockWallCastsLabel.text = ""
	if Globals.rock_wall_unlocked:
		%RockWallIcon.value = 1.0
		%RockWallCastsLabel.text = str(rock_wall_info.max_casts)
	
	%WindBlastIcon.value = 0.0
	%WindBlastCastsLabel.text = ""
	if Globals.wind_blast_unlocked:
		%WindBlastIcon.value = 1.0
		%WindBlastCastsLabel.text = str(wind_blast_info.max_casts)
	
	%LightningRayIcon.value = 0.0
	if Globals.lightning_ray_unlocked:
		%LightningRayIcon.value = 1.0


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


func _on_spell_casts_updated(spell: int) -> void:
	match spell:
		0: # Fireball
			%FireballCastsLabel.text = str(fireball_info.remaning_casts)
		1: # Rock wall
			%RockWallCastsLabel.text = str(rock_wall_info.remaning_casts)
		2: # Wind blast
			%WindBlastCastsLabel.text = str(wind_blast_info.remaning_casts)


func _on_spell_unlocked(spell: int) -> void:
	_on_spell_casts_updated(spell)
	match spell:
		0:
			%FireBallIcon.value = 1.0
			_on_notification_message_sent("Fireball learned")
		1:
			%RockWallIcon.value = 1.0
			_on_notification_message_sent("Rock wall learned")
		2:
			%WindBlastIcon.value = 1.0
			_on_notification_message_sent("Wind blast learned")
		3:
			%LightningRayIcon.value = 1.0
			_on_notification_message_sent("Lightning ray learned")


func _on_spell_recharge_started(spell: int) -> void:
	var color_tween: Tween = create_tween()
	match spell:
		0: # Fireball
			%FireBallIcon.value = 0.0
			color_tween.tween_property(%FireBallIcon, "value", 1.0, fireball_info.recharge_duration)
		1: # Rock wall
			%RockWallIcon.value = 0.0
			color_tween.tween_property(%RockWallIcon, "value", 1.0, rock_wall_info.recharge_duration)
		2: # Wind blast
			%WindBlastIcon.value = 0.0
			color_tween.tween_property(%WindBlastIcon, "value", 1.0, wind_blast_info.recharge_duration)


func _on_update_lightning_ray_icon(value: float) -> void:
	%LightningRayIcon.value = value


func _on_notification_message_sent(message: String) -> void:
	if notification_fade_tween:
		notification_fade_tween.stop()
	%NotificationLabel.modulate = Color.WHITE
	%NotificationLabel.text = message
	%NotificationTimer.start(0.0)
	await %NotificationTimer.timeout
	notification_fade_tween = create_tween()
	notification_fade_tween.tween_property(%NotificationLabel, "modulate", Color.TRANSPARENT, 1.0)
