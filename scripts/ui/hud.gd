extends Control

func _ready() -> void:
	SignalHub.update_interact_prompt.connect(_on_update_interact_prompt)
	SignalHub.update_health_bar.connect(_on_update_health_bar)
	%HealthBar.value = 1.0

func _process(_delta: float) -> void:
	%FpsLabel.text = str(Engine.get_frames_per_second())

func _on_update_interact_prompt(prompt: String) -> void:
	%InteractLabel.text = prompt

func _on_update_health_bar(value: float) -> void:
	%HealthBar.value = value
