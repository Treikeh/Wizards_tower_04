extends Control

func _ready() -> void:
	SignalHub.update_interact_prompt.connect(_on_update_interact_prompt)

func _process(_delta: float) -> void:
	%FpsLabel.text = str(Engine.get_frames_per_second())

func _on_update_interact_prompt(prompt: String) -> void:
	%InteractLabel.text = prompt
