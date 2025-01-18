class_name Enemy_Lancer
extends Enemy_Base

var rng = RandomNumberGenerator.new()

var MuzzleMain_defRot := Vector2(15,0)
var MuzzleLeft_defRot := Vector2(51,-15)
var MuzzleRight_defRot := Vector2(51,15)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$".".queue_free()

func shoot_main_laser():
	var l = laser_scene.instantiate()
	l.global_position = $MuzzleMain.global_position
	l.emit_signal("shotByAI")
	emit_signal("enemy_laser_shot", l, $".".movement_vector)
	

func shoot_side_laser():
	var l = laser_scene.instantiate()
	l.global_position = $MuzzleRight.global_position
	l.emit_signal("shotByAI")
	l.emit_signal("seeker")
	emit_signal("enemy_laser_shot", l, $".".movement_vector)
	
	var ll = laser_scene.instantiate()
	ll.global_position = $MuzzleLeft.global_position
	ll.emit_signal("shotByAI")
	ll.emit_signal("seeker")
	emit_signal("enemy_laser_shot", ll, $".".movement_vector)
	
func _ready() -> void:
	#Connect the enemy_base signal "enemy_laser_shot" to the parent's (Game) script's function (_on_enemy_laser_shot)
	var p = get_parent()
	self.enemy_laser_shot.connect(p._on_enemy_laser_shot)
	
	MuzzleMain_defRot = $MuzzleMain.position
	MuzzleLeft_defRot = $MuzzleLeft.position
	MuzzleRight_defRot = $MuzzleRight.position
	
	movement_vector = (get_node("/root/Game/Player").global_position - global_position).normalized()
	
	speed = 100
	scale = Vector2(0.5, 0.5)
	
	$Shoot.wait_time = rng.randf_range(1,3)
	$Shoot.start()
	$ShootAlt.wait_time = rng.randf_range(3,5)
	$ShootAlt.start()

func _process(delta: float) -> void:
	super._process(delta)
	$MuzzleMain.position = get_rotated_point($Sprite2D.frame, MuzzleMain_defRot)
	$MuzzleLeft.position = get_rotated_point($Sprite2D.frame, MuzzleLeft_defRot)
	$MuzzleRight.position = get_rotated_point($Sprite2D.frame, MuzzleRight_defRot)


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


func _on_shoot_timeout() -> void:
	shoot_main_laser()
	
	$Shoot.wait_time = rng.randf_range(1,3)
	$Shoot.start()


func _on_shoot_alt_timeout() -> void:
	shoot_side_laser()
	
	$ShootAlt.wait_time = rng.randf_range(3,5)
	$ShootAlt.start()
