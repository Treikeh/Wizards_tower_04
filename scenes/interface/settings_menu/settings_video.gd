extends Control


@export_group("Nodes")
@export var display_mode_options: OptionButton
@export var resolution_opions: OptionButton
@export var fov_slider: HSlider
@export var fov_value: SpinBox


func _ready() -> void:
	var video_settings: Dictionary = ConfigHandler.load_video_settings()
	# Display mode options
	match video_settings.display_mode:
		"FULLSCREEN":
			display_mode_options.select(0)
		"BORDERLESS_FULLSCREEN":
			display_mode_options.select(1)
		"WINDOWED":
			display_mode_options.select(2)
		"BORDERLESS_WINDOWED":
			display_mode_options.select(3)
	
	# Resolution opions
	var resolution: Vector2i = video_settings.resolution
	match str(resolution):
		"(720, 480)":
			resolution_opions.select(0)
		"(960, 540)":
			resolution_opions.select(1)
		"(1920, 1080)":
			resolution_opions.select(2)
	
	# Fov slider
	fov_slider.value = video_settings.field_of_view
	fov_value.value = video_settings.field_of_view


func _on_display_mode_item_selected(index: int) -> void:
	match index:
		0: # Fullscreen
			ConfigHandler.save_video_settings("display_mode", "FULLSCREEN")
		1: # Borderless fullscreen
			ConfigHandler.save_video_settings("display_mode", "BORDERLESS_FULLSCREEN")
		2: # Windowed
			ConfigHandler.save_video_settings("display_mode", "WINDOWED")
		3: # Borderless windowed
			ConfigHandler.save_video_settings("display_mode", "BORDERLESS_WINDOWED")


func _on_resolution_item_selected(index: int) -> void:
	match index:
		0: # 720 x 480
			ConfigHandler.save_video_settings("resolution", Vector2i(720, 480))
		1: # 960 x 540
			ConfigHandler.save_video_settings("resolution", Vector2i(960, 540))
		2: # 1920 x 1080
			ConfigHandler.save_video_settings("resolution", Vector2i(1920, 1080))


func _on_fov_slider_drag_ended(_value_changed: bool) -> void:
	fov_value.value = fov_slider.value
	ConfigHandler.save_video_settings("field_of_view", fov_slider.value)


func _on_fov_value_value_changed(_value: float) -> void:
	fov_slider.value = fov_value.value
	ConfigHandler.save_video_settings("field_of_view", fov_value.value)
