extends Control


@export_group("Nodes")
@export var fps_label: Label
@export var interact_label: Label
@export var health_bar: ProgressBar


func _ready() -> void:
	#TODO: Get the current health of the player
	health_bar.value = health_bar.max_value
	# Connect signals
	Globals.interact_prompt_updated.connect(_on_interact_prompt_updated)
	Globals.health_bar_updated.connect(_on_health_bar_updated)


func _input(event: InputEvent) -> void:
	# Spawn pause menu when pressing ESC
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Globals.main_scene.change_ui_scene("res://scenes/interface/pause_menu/pause_menu.tscn")


func _process(_delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second())


func _on_interact_prompt_updated(prompt: String) -> void:
	interact_label.text = prompt


func _on_health_bar_updated(value: float) -> void:
	health_bar.value = value
