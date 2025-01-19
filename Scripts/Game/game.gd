extends Node2D

@onready var lasers = $Lasers
#only to hold spawner script
@onready var enemies = $Enemies
@onready var player = $Player

func _on_player_laser_shot(laser: Variant) -> void:
	laser.set_collision_layer(0x0)
	laser.set_collision_layer_value(4, true)
	
	lasers.add_child(laser)
	laser.friendly = true
	#Vector set in laser.gd _ready()

func _on_enemy_laser_shot(laser: Variant, moveDir: Vector2) -> void:
	laser.set_collision_layer(0x0)
	laser.set_collision_layer_value(4, true)
	
	lasers.add_child(laser)
	laser.friendly = false
	laser.movement_vector_passed = moveDir

func _on_enemy_spawned(enemy: Variant):
	add_child(enemy)
	enemy.add_to_group("Enemy")
	#DEBUG:
	enemy.shield = 0
	#DEBUG:
	enemy.health = 1
	#Add variety to attack vector so enemy does not approach directly
	enemy.movement_vector = enemy.movement_vector.rotated(deg_to_rad(randi_range(-7,7)))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		SceneTransition.scene_transition("res://Scenes/Menu/Menu.tscn")
