extends Control

@export_group("Nodes")
@export var sensitivity_label: Label
@export var sensitivity_slider: HSlider

func _ready() -> void:
	var input_settings: Dictionary = ConfigHandler.load_input_settings()
	sensitivity_slider.value = input_settings.camera_sensitivity

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	sensitivity_label.text = "Sensitivity: " + str(sensitivity_slider.value)

@warning_ignore("unused_parameter")
func _on_sensitivity_slider_drag_ended(value_changed: bool) -> void:
	ConfigHandler.save_input_setting("camera_sensitivity", sensitivity_slider.value)
