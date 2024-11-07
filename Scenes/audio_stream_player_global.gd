extends AudioStreamPlayer

const lvl_music = preload("res://Audio/Music/MoSzat-combat.wav")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_music_level():
	_play_music(lvl_music) 
