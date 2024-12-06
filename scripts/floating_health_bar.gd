extends Sprite3D

@export var fade_duration: float = 1.0

@export_group("Nodes")
@export var progress_bar: ProgressBar
@export var fade_delay: Timer

var fade_tween: Tween

func _ready() -> void:
	progress_bar.value = progress_bar.max_value
	fade_delay.start(0.0)

func _on_health_changed(current_health: float, max_health: float) -> void:
	progress_bar.value = current_health / max_health
	show_health_bar()
	fade_delay.start(0.0)

func show_health_bar() -> void:
	if fade_tween:
		fade_tween.stop()
	modulate = Color.WHITE

func hide_health_bar() -> void:
	fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_duration)

func _on_fade_delay_timeout() -> void:
	hide_health_bar()
