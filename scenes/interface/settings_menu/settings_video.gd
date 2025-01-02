extends Control


@export_group("Nodes")
@export var display_mode_options: OptionButton
@export var resolution_opions: OptionButton
@export var fov_slider: HSlider
@export var fov_value: SpinBox


func _ready() -> void:
	var input_settings: Dictionary = ConfigHandler.load_video_settings()
	#display_mode_options
	#resolution_opions
	fov_slider.value = input_settings.field_of_view
	fov_value.value = input_settings.field_of_view


func _on_display_mode_item_selected(index: int) -> void:
	return
	@warning_ignore("unreachable_code")
	#FIXME:
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


func _on_fov_slider_drag_ended(_value_changed: bool) -> void:
	fov_value.value = fov_slider.value
	ConfigHandler.save_video_settings("field_of_view", fov_slider.value)


func _on_fov_value_value_changed(_value: float) -> void:
	fov_slider.value = fov_value.value
	ConfigHandler.save_video_settings("field_of_view", fov_value.value)
