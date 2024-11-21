extends CanvasLayer

#https://www.youtube.com/watch?v=yZQStB6nHuI

func scene_transition(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")
