extends Control


var resolution: Vector2i = Vector2i.ZERO

@export_group("Nodes")
@export var display_mode_options: OptionButton
@export var resolution_opions: OptionButton
@export var fov_slider: HSlider
@export var fov_value: SpinBox


#TODO: Apply settings changes when game starts
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
	resolution = video_settings.resolution
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
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			ConfigHandler.save_video_settings("display_mode", "FULLSCREEN")
		1: # Borderless fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			ConfigHandler.save_video_settings("display_mode", "BORDERLESS_FULLSCREEN")
		2: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			ConfigHandler.save_video_settings("display_mode", "WINDOWED")
		3: # Borderless windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			ConfigHandler.save_video_settings("display_mode", "BORDERLESS_WINDOWED")
	# Set game resolution
	DisplayServer.window_set_size(resolution)
	_center_window()


func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			resolution = Vector2i(720, 480)
			DisplayServer.window_set_size(resolution)
			ConfigHandler.save_video_settings("resolution", resolution)
		1:
			resolution = Vector2i(960, 540)
			DisplayServer.window_set_size(resolution)
			ConfigHandler.save_video_settings("resolution", resolution)
		2:
			resolution = Vector2i(1920, 1080)
			DisplayServer.window_set_size(resolution)
			ConfigHandler.save_video_settings("resolution", resolution)
	# Center window
	_center_window()


func _on_fov_slider_drag_ended(_value_changed: bool) -> void:
	fov_value.value = fov_slider.value
	ConfigHandler.save_video_settings("field_of_view", fov_slider.value)


func _on_fov_value_value_changed(_value: float) -> void:
	fov_slider.value = fov_value.value
	ConfigHandler.save_video_settings("field_of_view", fov_value.value)


func _center_window() -> void:
	pass
