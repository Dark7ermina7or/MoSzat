extends Control

#Audio sliders
#https://www.youtube.com/watch?v=aFkRmtGiZCw

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/VolumeSliderMain.grab_focus()
	match DisplayServer.window_get_size():
		Vector2i(1920,1080):
			$MarginContainer/VBoxContainer/OptionButtonResolution.select(0)
		Vector2i(1600,900):
			$MarginContainer/VBoxContainer/OptionButtonResolution.select(1)
		Vector2i(1280,720):
			$MarginContainer/VBoxContainer/OptionButtonResolution.select(2)
	
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			$MarginContainer/VBoxContainer/CheckButtonFullscreen.button_pressed = true
		DisplayServer.WINDOW_MODE_WINDOWED:
			$MarginContainer/VBoxContainer/CheckButtonFullscreen.button_pressed = false
	
	$MarginContainer/VBoxContainer/MuteButtonMain.button_pressed = AudioServer.is_bus_mute(0)
	$MarginContainer/VBoxContainer/MuteButtonSFX.button_pressed = AudioServer.is_bus_mute(1)
	$MarginContainer/VBoxContainer/MuteButtonMusic.button_pressed = AudioServer.is_bus_mute(2)
	
	$MarginContainer/VBoxContainer/VolumeSliderMain.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$MarginContainer/VBoxContainer/VolumeSliderSFX.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$MarginContainer/VBoxContainer/VolumeSliderMusic.value = db_to_linear(AudioServer.get_bus_volume_db(2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_volume_slider_main_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db(value))


func _on_mute_button_main_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

func _on_volume_slider_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(value))


func _on_mute_button_sfx_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1,toggled_on)


func _on_volume_slider_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,linear_to_db(value))


func _on_mute_button_music_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2,toggled_on)


func _on_option_button_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
		
	DisplayServer.window_set_position(Vector2i((DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2),0)


func _on_check_button_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _SFX_player_Item_focus_changed() -> void:
	$AudioStreamPlayerSFX.play()
