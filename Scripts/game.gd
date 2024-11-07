extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player

func _on_player_laser_shot(laser: Variant) -> void:
	lasers.add_child(laser)
