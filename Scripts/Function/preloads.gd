extends Node

const music = preload("res://Audio/Music/MoSzat-combat.wav")
const sfx_gui_conf = preload("res://Audio/SFX/MenuSelectFX.wav")
const sfx_laser_shot = preload("res://Audio/SFX/AttackFX.wav")
const sfx_laser_shot_alt = preload("res://Audio/SFX/AttackFX2.wav")
const sfx_player_death = preload("res://Audio/SFX/PlayerDeathFX.wav")
const scene_laser = preload("res://Scenes/Game/laser.tscn")
const player = preload("res://Scenes/Game/player.tscn")
const enemy_support = preload("res://Scenes/Game/enemy_support.tscn")
const enemy_lancer = preload("res://Scenes/Game/enemy_lancer.tscn")
const enemy_bulwark = preload("res://Scenes/Game/enemy_bulwark.tscn")
const enemy_interceptor = preload("res://Scenes/Game/enemy_interceptor.tscn")
const enemy_boss = preload("res://Scenes/Game/enemy_boss.tscn")
const explosion = preload("res://Scenes/Game/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
