extends Control

#Audio sliders
#https://www.youtube.com/watch?v=aFkRmtGiZCw

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/VolumeSliderMain.grab_focus()
	DisplayServer.window_set_title("MoSzat")
	#match DisplayServer.window_get_size():
		#Vector2i(1920,1080):
			#$MarginContainer/VBoxContainer/OptionButtonResolution.select(0)
		#Vector2i(1600,900):
			#$MarginContainer/VBoxContainer/OptionButtonResolution.select(1)
		#Vector2i(1280,720):
			#$MarginContainer/VBoxContainer/OptionButtonResolution.select(2)
	#
	#match DisplayServer.window_get_mode():
		#DisplayServer.WINDOW_MODE_FULLSCREEN:
			#$MarginContainer/VBoxContainer/CheckButtonFullscreen.button_pressed = true
		#DisplayServer.WINDOW_MODE_WINDOWED:
			#$MarginContainer/VBoxContainer/CheckButtonFullscreen.button_pressed = false
	
	var video_settings = ConfigFileHandler.load_video_settings()
	var audio_settings = ConfigFileHandler.load_audio_settings()
	
	$MarginContainer/VBoxContainer/CheckButtonFullscreen.button_pressed = video_settings.fullscreen
	$MarginContainer/VBoxContainer/OptionButtonResolution.select(video_settings.resolution)
	
	if video_settings.fullscreen:
		$MarginContainer/VBoxContainer/OptionButtonResolution.disabled = true
	else:
		$MarginContainer/VBoxContainer/OptionButtonResolution.disabled = false
	
	$MarginContainer/VBoxContainer/MuteButtonMain.button_pressed = audio_settings.main_mute
	$MarginContainer/VBoxContainer/MuteButtonSFX.button_pressed = audio_settings.sfx_mute
	$MarginContainer/VBoxContainer/MuteButtonMusic.button_pressed = audio_settings.music_mute
	
	$MarginContainer/VBoxContainer/VolumeSliderMain.value = db_to_linear(audio_settings.main_volume)
	$MarginContainer/VBoxContainer/VolumeSliderSFX.value = db_to_linear(audio_settings.sfx_volume)
	$MarginContainer/VBoxContainer/VolumeSliderMusic.value = db_to_linear(audio_settings.music_volume)
	
	DisplayServer.window_set_position(Vector2i((DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2),0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	SceneTransition.scene_transition("res://Scenes/menu.tscn")


func _on_volume_slider_main_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db(value))

func _on_mute_button_main_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
	
	ConfigFileHandler.save_audio_settings("main_mute", toggled_on)

func _on_volume_slider_main_drag_ended(value_changed: bool) -> void:
	ConfigFileHandler.save_audio_settings("main_volume", linear_to_db($MarginContainer/VBoxContainer/VolumeSliderMain.value))


func _on_volume_slider_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(value))

func _on_mute_button_sfx_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1,toggled_on)
	
	ConfigFileHandler.save_audio_settings("sfx_mute", toggled_on)

func _on_volume_slider_sfx_drag_ended(value_changed: bool) -> void:
	ConfigFileHandler.save_audio_settings("sfx_volume", linear_to_db($MarginContainer/VBoxContainer/VolumeSliderSFX.value))


func _on_volume_slider_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,linear_to_db(value))

func _on_mute_button_music_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2,toggled_on)
	
	ConfigFileHandler.save_audio_settings("music_mute", toggled_on)

func _on_volume_slider_music_drag_ended(value_changed: bool) -> void:
	ConfigFileHandler.save_audio_settings("music_volume", linear_to_db($MarginContainer/VBoxContainer/VolumeSliderMusic.value))


func _on_option_button_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
		
	DisplayServer.window_set_position(Vector2i((DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2),0)
	
	ConfigFileHandler.save_video_settings("resolution", index)


func _on_check_button_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$MarginContainer/VBoxContainer/OptionButtonResolution.disabled = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$MarginContainer/VBoxContainer/OptionButtonResolution.disabled = false
	
	ConfigFileHandler.save_video_settings("fullscreen", toggled_on)



func _SFX_player_Item_focus_changed() -> void:
	#$AudioStreamPlayerSFX.play()
	return
