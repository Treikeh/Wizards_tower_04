extends MarginContainer


func _ready() -> void:
	# Load video settings
	var video_settings: Dictionary = ConfigHandler.load_video_settings()
	# Display mode options
	match video_settings.display_mode:
		"FULLSCREEN":
			%DisplayOptions.select(0)
		"BORDERLESS_FULLSCREEN":
			%DisplayOptions.select(1)
		"WINDOWED":
			%DisplayOptions.select(2)
		"BORDERLESS_WINDOWED":
			%DisplayOptions.select(3)
	
	# Resolution opions
	var resolution: Vector2i = video_settings.resolution
	match str(resolution):
		"(720, 480)":
			%ResolutionOptions.select(0)
		"(960, 540)":
			%ResolutionOptions.select(1)
		"(1920, 1080)":
			%ResolutionOptions.select(2)
	
	# Fov slider
	%FovSlider.value = video_settings.field_of_view
	%FovValue.value = video_settings.field_of_view
	
	# Load input settings
	var input_settings: Dictionary = ConfigHandler.load_input_settings()
	%SensitivitySlider.value = input_settings.camera_sensitivity
	%SensitivityValue.value = input_settings.camera_sensitivity


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and visible:
		queue_free()


func _on_back_button_pressed() -> void:
	queue_free()


#region Video settings

func _on_display_options_item_selected(index: int) -> void:
	match index:
		0: # Fullscreen
			ConfigHandler.save_video_settings("display_mode", "FULLSCREEN")
		1: # Borderless fullscreen
			ConfigHandler.save_video_settings("display_mode", "BORDERLESS_FULLSCREEN")
		2: # Windowed
			ConfigHandler.save_video_settings("display_mode", "WINDOWED")
		3: # Borderless windowed
			ConfigHandler.save_video_settings("display_mode", "BORDERLESS_WINDOWED")
	
	ConfigHandler.apply_video_settings()


func _on_resolution_options_item_selected(index: int) -> void:
	match index:
		0: # 720 x 480
			ConfigHandler.save_video_settings("resolution", Vector2i(720, 480))
		1: # 960 x 540
			ConfigHandler.save_video_settings("resolution", Vector2i(960, 540))
		2: # 1920 x 1080
			ConfigHandler.save_video_settings("resolution", Vector2i(1920, 1080))


func _on_fov_slider_drag_ended(_value_changed: bool) -> void:
	%FovValue.value = %FovSlider.value
	ConfigHandler.save_video_settings("field_of_view", %FovSlider.value)


func _on_fov_value_value_changed(_value: float) -> void:
	%FovSlider.value = %FovValue.value
	ConfigHandler.save_video_settings("field_of_view", %FovValue.value)

#endregion


#region Input settings

func _on_sensitivity_slider_drag_ended(_value_changed: bool) -> void:
	%SensitivityValue.value = %SensitivitySlider.value
	ConfigHandler.save_input_setting("camera_sensitivity", %SensitivitySlider.value)


func _on_sensitivity_value_value_changed(_value: float) -> void:
	%SensitivitySlider.value = %SensitivityValue.value
	ConfigHandler.save_input_setting("camera_sensitivity", %SensitivityValue.value)

#endregion
