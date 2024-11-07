extends Node

#https://www.youtube.com/watch?v=tfqJjDw0o7Y

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready():
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("Video", "fullscreen", false)
		config.set_value("Video", "resolution", 2)
		
		config.set_value("Audio", "main_volume", 1.0)
		config.set_value("Audio", "main_mute", false)
		config.set_value("Audio", "music_volume", 1.0)
		config.set_value("Audio", "music_mute", false)
		config.set_value("Audio", "sfx_volume", 1.0)
		config.set_value("Audio", "sfx_mute", false)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func save_video_settings(key: String, value):
	config.set_value("Video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("Video"):
		video_settings[key] = config.get_value("Video", key)
	return video_settings

func save_audio_settings(key: String, value):
	config.set_value("Audio", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("Audio"):
		audio_settings[key] = config.get_value("Audio", key)
	return audio_settings
