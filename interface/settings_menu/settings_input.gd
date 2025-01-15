extends Control


func _ready() -> void:
	# Load input settings
	var input_settings: Dictionary = ConfigHandler.load_input_settings()
	%SensitivitySlider.value = input_settings.camera_sensitivity
	%SensitivityValue.value = input_settings.camera_sensitivity


func _on_sensitivity_slider_drag_ended(_value_changed: bool) -> void:
	%SensitivityValue.value = %SensitivitySlider.value
	ConfigHandler.save_input_setting("camera_sensitivity", %SensitivitySlider.value)


func _on_sensitivity_value_value_changed(_value: float) -> void:
	%SensitivitySlider.value = %SensitivityValue.value
	ConfigHandler.save_input_setting("camera_sensitivity", %SensitivityValue.value)
