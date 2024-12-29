extends Control


@export_group("Nodes")
@export var sensitivity_slider: HSlider
@export var sensitivity_value: LineEdit


func _ready() -> void:
	var input_settings: Dictionary = ConfigHandler.load_input_settings()
	sensitivity_slider.value = input_settings.camera_sensitivity
	sensitivity_value.text = str(sensitivity_slider.value)


func _on_sensitivity_slider_drag_ended(_value_changed: bool) -> void:
	sensitivity_value.text = str(sensitivity_slider.value)
	ConfigHandler.save_input_setting("camera_sensitivity", sensitivity_slider.value)


func _on_sensitivity_value_text_submitted(new_text: String) -> void:
	sensitivity_slider.value = float(new_text)
	sensitivity_value.text = str(sensitivity_slider.value)
	ConfigHandler.save_input_setting("camera_sensitivity", sensitivity_slider.value)
