extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var video_settings = ConfigFileHandler.load_video_settings()
	
	DisplayServer.window_set_title("MoSzat")
	match video_settings.resolution:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
		
	DisplayServer.window_set_position(Vector2i((DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2),0)
	
	if video_settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	
	AudioServer.set_bus_volume_db(0,audio_settings.main_volume)
	AudioServer.set_bus_mute(0,audio_settings.main_mute)
	AudioServer.set_bus_volume_db(1,audio_settings.sfx_volume)
	AudioServer.set_bus_mute(1,audio_settings.sfx_mute)
	AudioServer.set_bus_volume_db(2,audio_settings.music_volume)
	AudioServer.set_bus_mute(2,audio_settings.music_mute)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
