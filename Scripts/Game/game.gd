extends Node2D

@onready var lasers = $Lasers
#only to hold spawner script
@onready var enemies = $Enemies
@onready var player = $Player

@onready var map: Node = $Map

var highscore = ConfigFileHandler.load_score_settings()
signal enteredRoom()

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

func _ready() -> void:
	emit_signal("enteredRoom")

func setBoundary(nesw):
	$TopBarrier/TopColShape.set_deferred("disabled", nesw[0])
	$TopBarrier/TopColorRect.visible = !nesw[0]
	$RightBarrier/RightColShape.set_deferred("disabled", nesw[1])
	$RightBarrier/RightColorRect.visible = !nesw[1]
	$BottomBarrier/BottomColShape.set_deferred("disabled", nesw[2])
	$BottomBarrier/BottomColorRect.visible = !nesw[2]
	$LeftBarrier/LeftColShape.set_deferred("disabled", nesw[3])
	$LeftBarrier/LeftColorRect.visible = !nesw[3]

func _on_entered_room() -> void:
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	for laser in get_tree().get_nodes_in_group("Projectile"):
		laser.queue_free()
	if map.currentY == map.endY and map.currentX == map.endX:
		SceneTransition.scene_transitionMsg("res://Scenes/Menu/menu.tscn", "VICTORY")
	
	setBoundary(map.rooms[map.map[map.currentY][map.currentX]])


func _on_player_screen_exited() -> void:
	#UP
	if player.global_position.y < 0-10:
		#LEFTCORNER
		if player.global_position.x < 0-10:
			if player.global_position.y <= player.global_position.x:
				player.global_position.y = 720+10
				map.currentY = map.currentY - 1
			else:
				player.global_position.x = 1280+10
				map.currentX = map.currentX - 1
				
		#RIGHTCORNER
		if player.global_position.x > 1280+10:
			if player.global_position.y + 1280 >= player.global_position.x:
				player.global_position.y = 720+10
				map.currentY = map.currentY - 1
			else:
				player.global_position.x = 0-10
				map.currentX = map.currentX + 1
		#UP
		else:
			player.global_position.y = 720+10
			map.currentY = map.currentY - 1
	
	#DOWN
	if player.global_position.y > 720+10:
		#LEFTCORNER
		if player.global_position.x < 0-10:
			if player.global_position.y <= player.global_position.x:
				player.global_position.y = 0-10
				map.currentY = map.currentY + 1
			else:
				player.global_position.x = 1280+10
				map.currentX = map.currentX - 1
		#RIGHTCORNER
		if player.global_position.x > 1280+10:
			if player.global_position.y + 1280 >= player.global_position.x:
				player.global_position.y = 0-10
				map.currentX = map.currentX + 1
		#DOWN
		else:
			player.global_position.y = 0-10
			map.currentY = map.currentY + 1
	
	#RIGHT
	if player.global_position.x > 1280+10:
		player.global_position.x = 0-10
		map.currentX = map.currentX + 1
	
	#LEFT
	if player.global_position.x < 0-10:
		player.global_position.x = 1280+10
		map.currentX = map.currentX - 1
	
	emit_signal("enteredRoom")
