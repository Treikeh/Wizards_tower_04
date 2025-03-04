extends Control


@export_file("*.tscn") var pause_menu_scene: String

var notification_duration: float = 3.0
var notification_fade_tween: Tween


func _ready() -> void:
	# Connect signals
	Globals.interact_prompt_updated.connect(_on_interact_prompt_updated)
	Globals.health_bar_updated.connect(_on_health_bar_updated)
	Globals.notification_message_sent.connect(_on_notification_message_sent)
	
	%NotificationTimer.wait_time = notification_duration
	
	# Set starting health
	#TODO: I need a system that saves player data across levels.
	%HealthBar.value = %HealthBar.max_value
	%NotificationLabel.modulate = Color.TRANSPARENT


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


func _on_notification_message_sent(message: String) -> void:
	if notification_fade_tween:
		notification_fade_tween.stop()
	%NotificationLabel.modulate = Color.WHITE
	%NotificationLabel.text = message
	%NotificationTimer.start(0.0)
	await %NotificationTimer.timeout
	notification_fade_tween = create_tween()
	notification_fade_tween.tween_property(%NotificationLabel, "modulate", Color.TRANSPARENT, 1.0)
