extends CanvasLayer

#https://www.youtube.com/watch?v=yZQStB6nHuI
var targetPass

func _ready() -> void:
	$CenterContainer/Label.text = ""

func scene_transition(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")

func scene_transitionMsg(target: String, msg: String) -> void:
	targetPass = target
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	$msgWait.wait_time = 5
	$msgWait.start()
	$CenterContainer/Label.text = msg


func _on_msg_wait_timeout() -> void:
	get_tree().change_scene_to_file(targetPass)
	$AnimationPlayer.play_backwards("dissolve")
	$CenterContainer/Label.text = ""
