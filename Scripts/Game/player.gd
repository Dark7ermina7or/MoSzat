class_name Player
extends CharacterBody2D

@export var acceleration := 150
@export var max_speed := 500
@export var canShoot := true
@export var score = 0

var explosion_scene = Preloads.explosion
var laser_scene = Preloads.scene_laser
var MuzzleMain_defRot := Vector2(26,0)

var CollisionShape_defRot := Vector2(0, 0)
var CollisionShape2_defRot := Vector2(9, -27)
var CollisionShape3_defRot := Vector2(9, 27)

var CollisionShape4_defRot := Vector2(0, 0)
var CollisionShape5_defRot := Vector2(9, -27)
var CollisionShape6_defRot := Vector2(9, 27)

signal player_laser_shot(laser)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("action_shoot"):
		if canShoot:
			shoot_laser()

func _physics_process(_delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	velocity = acceleration * input_direction
	velocity = velocity.limit_length(max_speed)
	
	set_rotated_frame()
	$MuzzleMain.position = get_rotated_point($Sprite2D.frame, MuzzleMain_defRot)
	
	$CollisionShape2D.position = get_rotated_point($Sprite2D.frame, CollisionShape_defRot)
	$CollisionShape2D2.position = get_rotated_point($Sprite2D.frame, CollisionShape2_defRot)
	$CollisionShape2D3.position = get_rotated_point($Sprite2D.frame, CollisionShape3_defRot)
	$CollisionShape2D.rotation = (get_global_mouse_position() - global_position).angle()
	$CollisionShape2D2.rotation = (get_global_mouse_position() - global_position).angle()
	$CollisionShape2D3.rotation = (get_global_mouse_position() - global_position).angle()
	
	$Area2D/CollisionShape2D4.position = get_rotated_point($Sprite2D.frame, CollisionShape4_defRot)
	$Area2D/CollisionShape2D5.position = get_rotated_point($Sprite2D.frame, CollisionShape5_defRot)
	$Area2D/CollisionShape2D6.position = get_rotated_point($Sprite2D.frame, CollisionShape6_defRot)
	$Area2D/CollisionShape2D4.rotation = (get_global_mouse_position() - global_position).angle()
	$Area2D/CollisionShape2D5.rotation = (get_global_mouse_position() - global_position).angle()
	$Area2D/CollisionShape2D6.rotation = (get_global_mouse_position() - global_position).angle()
	
	move_and_slide()

func _ready() -> void:
	MuzzleMain_defRot = $MuzzleMain.position
	#print("asd")
	add_to_group("Player")
	
	set_collision_layer(0x0)
	set_collision_layer_value(2, true)
	
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(4, true)
	
	$Area2D.set_collision_layer(0x0)
	$Area2D.set_collision_layer_value(2, true)
	
	$Area2D.set_collision_mask_value(1, true)
	$Area2D.set_collision_mask_value(2, true)
	$Area2D.set_collision_mask_value(3, true)
	$Area2D.set_collision_mask_value(4, true)

func get_rotated_point(frame: int, initial_offset: Vector2) -> Vector2:
	# Calculate the angle for the given frame (in degrees)
	var angle_deg = (frame % $Sprite2D.hframes) * (360.0 / $Sprite2D.hframes)
	# Convert angle to radians
	var angle_rad = deg_to_rad(angle_deg)
	# Rotate the initial offset by the calculated angle
	var rotated_x = initial_offset.x * cos(angle_rad) - initial_offset.y * sin(angle_rad)
	var rotated_y = initial_offset.x * sin(angle_rad) + initial_offset.y * cos(angle_rad)
	# Return the new rotated position relative to the ship's pivot
	return Vector2(rotated_x, rotated_y)

func set_rotated_frame():
	var direction = get_global_mouse_position() - global_position
	var angle_degrees = rad_to_deg(direction.angle())

	if angle_degrees < 0:
		angle_degrees += 360

	angle_degrees = int (angle_degrees + 11.25) % 360

	var frame_index = int((angle_degrees / 360.0) * $Sprite2D.hframes)
	$Sprite2D.frame = frame_index % $Sprite2D.hframes

func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = $MuzzleMain.global_position
	l.emit_signal("shotByPlayer")
	emit_signal("player_laser_shot", l)


func death():
	var e = explosion_scene.instantiate()
	e.global_position = self.global_position
	get_parent().find_child("Lasers").add_child(e)
	get_parent().find_child("Enemies").canSpawn = false
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	for laser in get_tree().get_nodes_in_group("Projectile"):
		laser.queue_free()
	
	#queue_free()
	$Sprite2D.visible = false
	canShoot = false
	
	if score > get_parent().highscore:
		ConfigFileHandler.save_score_settings("score", score)
	
	SceneTransition.scene_transition("res://Scenes/Menu/menu.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Laser:
		if area.friendly:
			pass
		else:
			death()
	else:
		death()
	



func _on_area_2d_body_entered(_body: Node2D) -> void:
	pass
