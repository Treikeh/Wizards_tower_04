extends Control


@export_group("Nodes")
@export var fov_slider: HSlider
@export var fov_value: SpinBox


func _ready() -> void:
	var input_settings: Dictionary = ConfigHandler.load_video_settings()
	fov_slider.value = input_settings.field_of_view
	fov_value.value = input_settings.field_of_view


func _on_fov_slider_drag_ended(_value_changed: bool) -> void:
	fov_value.value = fov_slider.value
	ConfigHandler.save_video_settings("field_of_view", fov_slider.value)


func _on_fov_value_value_changed(_value: float) -> void:
	fov_slider.value = fov_value.value
	ConfigHandler.save_video_settings("field_of_view", fov_value.value)
