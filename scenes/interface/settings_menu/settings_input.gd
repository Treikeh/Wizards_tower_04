extends Control


@export_group("Nodes")
@export var sensitivity_slider: HSlider
@export var sensitivity_value: SpinBox


func _ready() -> void:
	var input_settings: Dictionary = ConfigHandler.load_input_settings()
	sensitivity_slider.value = input_settings.camera_sensitivity
	sensitivity_value.value = input_settings.camera_sensitivity


func _on_sensitivity_slider_drag_ended(_value_changed: bool) -> void:
	sensitivity_value.value = sensitivity_slider.value
	ConfigHandler.save_input_setting("camera_sensitivity", sensitivity_slider.value)


func _on_spin_box_value_changed(_value: float) -> void:
	sensitivity_slider.value = sensitivity_value.value
	ConfigHandler.save_input_setting("camera_sensitivity", sensitivity_value.value)
