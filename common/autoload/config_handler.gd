extends Node


signal input_settings_changed
signal keybindings_changed
signal video_settings_changed


#TODO: Change to proper path when shipping
# user://settings.ini
# res://configs/.settings.ini
const CONFIG_PATH: String = "res://configs/settings.ini"

var config_file: ConfigFile = ConfigFile.new()


func _ready() -> void:
	if not FileAccess.file_exists(CONFIG_PATH):
		# Create new config file with all the settings.
		# Remember to delete settings.ini file when adding new elements
		config_file.set_value("INPUT", "camera_sensitivity", 0.1)
		
		config_file.set_value("KEYBINDINGS", "move_f", "W")
		config_file.set_value("KEYBINDINGS", "move_b", "S")
		config_file.set_value("KEYBINDINGS", "move_l", "A")
		config_file.set_value("KEYBINDINGS", "move_r", "D")
		config_file.set_value("KEYBINDINGS", "jump", "space")
		config_file.set_value("KEYBINDINGS", "interact", "E")
		
		config_file.set_value("VIDEO", "display_mode", "FULLSCREEN")
		config_file.set_value("VIDEO", "resolution", Vector2i(960, 540))
		config_file.set_value("VIDEO", "field_of_view", 90.0)
		
		config_file.set_value("AUDIO", "master_volume", 1.0)
		
		config_file.save(CONFIG_PATH)
	else:
		# Load config file
		config_file.load(CONFIG_PATH)
	
	apply_video_settings()
	apply_audio_settings()


#region Video

func save_video_settings(key: String, value) -> void:
	config_file.set_value("VIDEO", key, value)
	config_file.save(CONFIG_PATH)
	video_settings_changed.emit()


func load_video_settings() -> Dictionary:
	var video_settings: Dictionary = {}
	for key in config_file.get_section_keys("VIDEO"):
		video_settings[key] = config_file.get_value("VIDEO", key)
	return video_settings


func apply_video_settings() -> void:
	var video_settings: Dictionary = load_video_settings()
	if video_settings.is_empty():
		return
	
	# Set display mode
	match video_settings.display_mode:
		"FULLSCREEN":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		"BORDERLESS_FULLSCREEN":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		"WINDOWED":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		"BORDERLESS_WINDOWED":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	
	# Set resolution when game starts
	var resolution: String = str(video_settings.resolution)
	match resolution:
		"(720, 480)":
			DisplayServer.window_set_size(Vector2i(720, 480))
		"(960, 540)":
			DisplayServer.window_set_size(Vector2i(960, 540))
		"(1920, 1080)":
			DisplayServer.window_set_size(Vector2i(1920, 1080))
	
	#TODO: Center window after loading video settings


#endregion


#region Audio

func save_audio_settings(key: String, value) -> void:
	config_file.set_value("AUDIO", key, value)
	config_file.save(CONFIG_PATH)
	video_settings_changed.emit()


func load_audio_settings() -> Dictionary:
	var audio_settings: Dictionary = {}
	for key in config_file.get_section_keys("AUDIO"):
		audio_settings[key] = config_file.get_value("AUDIO", key)
	return audio_settings


func apply_audio_settings() -> void:
	var audio_settings: Dictionary = load_audio_settings()
	if audio_settings.is_empty():
		return
	
	AudioServer.set_bus_volume_db(0, linear_to_db(audio_settings.master_volume))

#endregion


#region Inputs

func save_input_setting(key: String, value) -> void:
	config_file.set_value("INPUT", key, value)
	config_file.save(CONFIG_PATH)
	input_settings_changed.emit()


func load_input_settings() -> Dictionary:
	var input_settings: Dictionary = {}
	for key in config_file.get_section_keys("INPUT"):
		input_settings[key] = config_file.get_value("INPUT", key)
	return input_settings

#endregion


#region keybindings

func save_keybindings(key: String, value) -> void:
	config_file.set_value("KEYBINDINGS", key, value)
	config_file.save(CONFIG_PATH)
	keybindings_changed.emit()


func load_keybindings() -> Dictionary:
	var keybindings: Dictionary = {}
	for key in config_file.get_section_keys("KEYBINDINGS"):
		keybindings[key] = config_file.get_value("KEYBINDINGS", key)
	return keybindings

#endregion
