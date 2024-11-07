extends AudioStreamPlayer

#https://www.youtube.com/watch?v=lILnUD3xph8
#const lvl_music = preload("res://Audio/Music/MoSzat-combat.wav")

func play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

#func play_music_level():
	#_play_music(lvl_music) 

func play_SFX(stream: AudioStream, volume = 0.0):
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.name = "SFX_Player"
	sfx_player.bus = "SFX"
	sfx_player.volume_db = volume
	add_child(sfx_player)
	sfx_player.play()
	
	await sfx_player.finished
	sfx_player.queue_free()
