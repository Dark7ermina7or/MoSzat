extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player

func _on_player_laser_shot(laser: Variant) -> void:
	lasers.add_child(laser)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		SceneTransition.scene_transition("res://Scenes/Menu/Menu.tscn")
