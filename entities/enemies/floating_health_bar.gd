extends Sprite3D


@export var fade_duration: float = 1.0

var fade_tween: Tween

@onready var fade_delay: Timer = $FadeDelay
@onready var progress_bar: ProgressBar = $SubViewport/MarginContainer/ProgressBar


func _ready() -> void:
	progress_bar.value = progress_bar.max_value
	modulate = Color.TRANSPARENT


func _on_health_changed(current_health: float, max_health: float) -> void:
	progress_bar.value = current_health / max_health
	# Stop fading
	if fade_tween:
		fade_tween.stop()
	# Show health bar
	modulate = Color.WHITE
	fade_delay.start(0.0)


func _on_fade_delay_timeout() -> void:
	# Hide health bar
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_duration)
