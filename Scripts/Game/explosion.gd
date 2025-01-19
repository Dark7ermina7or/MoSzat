extends Node2D

func _ready() -> void:
	#$pre.visible = true
	$pre.rotation = randi_range(0,359)
	$post.rotation = randi_range(0,359)
	#$pre.play("pre")
	#$post.visible = false
	
	$pre.visible = false
	$post.visible = true
	$post.play("post")

func _on_pre_animation_finished() -> void:
	$pre.visible = false
	$post.visible = true
	$post.play("post")


func _on_post_animation_finished() -> void:
	$".".queue_free()
