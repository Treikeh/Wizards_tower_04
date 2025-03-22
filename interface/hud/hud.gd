extends Control


@export_file("*.tscn") var pause_menu_scene: String

var notification_duration: float = 3.0
var notification_fade_tween: Tween

var health_bar_value: float = 1.0
var damage_effect_tween: Tween


func _ready() -> void:
	# Connect signals
	Globals.interact_prompt_updated.connect(_on_interact_prompt_updated)
	Globals.health_bar_updated.connect(_on_health_bar_updated)
	Globals.notification_message_sent.connect(_on_notification_message_sent)
	
	%NotificationTimer.wait_time = notification_duration
	%NotificationLabel.modulate = Color.TRANSPARENT
	# Set starting health value
	health_bar_value = Globals.player_health / 100.0
	%DamageCornerEffect.modulate = Color.TRANSPARENT


func _process(_delta: float) -> void:
	%FpsLabel.text = str(Engine.get_frames_per_second())
	
	# Pause game when pressing ESC
	if Input.is_action_just_pressed("ui_cancel") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
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
	if damage_effect_tween:
		damage_effect_tween.stop()
	#HACK: This is not the best way of doing this, but i don't have time to redesign the health ->
	# <- system to allow me check if damage was taken or recived
	if value < health_bar_value:
		%DamageCornerEffect.modulate = Color.RED
	elif value > health_bar_value:
		%DamageCornerEffect.modulate = Color.GREEN
	else: # Health bar value is the same as value therefore nothing should happen
		return
	health_bar_value = value
	damage_effect_tween = create_tween()
	damage_effect_tween.tween_property(%DamageCornerEffect, "modulate", Color.TRANSPARENT, 0.3)


func _on_notification_message_sent(message: String) -> void:
	if notification_fade_tween:
		notification_fade_tween.stop()
	%NotificationLabel.modulate = Color.WHITE
	%NotificationLabel.text = message
	%NotificationTimer.start(0.0)
	await %NotificationTimer.timeout
	notification_fade_tween = create_tween()
	notification_fade_tween.tween_property(%NotificationLabel, "modulate", Color.TRANSPARENT, 1.0)
