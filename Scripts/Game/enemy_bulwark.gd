class_name Enemy_Bulwark
extends Enemy_Base

var rng = RandomNumberGenerator.new()

var MuzzleMain_defRot := Vector2(-4,0)
var MuzzleLeft_defRot := Vector2(17,-23)
var MuzzleLeft2_defRot := Vector2(5,-45)
var MuzzleRight_defRot := Vector2(17,23)
var MuzzleRight2_defRot := Vector2(5,45)

var CollisionShape_defRot := Vector2(-6, 0)
var CollisionShape2_defRot := Vector2(-31, 0)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$".".queue_free()

func shoot_main_laser():
	var l = laser_scene.instantiate()
	l.global_position = $MuzzleMain.global_position
	l.emit_signal("shotByAI")
	l.emit_signal("seeker")
	emit_signal("enemy_laser_shot", l, $".".movement_vector)
	

func shoot_side_laser():
	var l = laser_scene.instantiate()
	l.global_position = $MuzzleRight.global_position
	l.emit_signal("shotByAI")
	#l.emit_signal("seeker")
	emit_signal("enemy_laser_shot", l, $".".movement_vector)
	
	var ll = laser_scene.instantiate()
	ll.global_position = $MuzzleLeft.global_position
	ll.emit_signal("shotByAI")
	#ll.emit_signal("seeker")
	emit_signal("enemy_laser_shot", ll, $".".movement_vector)
	
	var lll = laser_scene.instantiate()
	lll.global_position = $MuzzleRight2.global_position
	lll.emit_signal("shotByAI")
	#lll.emit_signal("seeker")
	emit_signal("enemy_laser_shot", lll, $".".movement_vector)
	
	var llll = laser_scene.instantiate()
	llll.global_position = $MuzzleLeft2.global_position
	llll.emit_signal("shotByAI")
	#llll.emit_signal("seeker")
	emit_signal("enemy_laser_shot", llll, $".".movement_vector)
	
func _ready() -> void:
	#Connect the enemy_base signal "enemy_laser_shot" to the parent's (Game) script's function (_on_enemy_laser_shot)
	var p = get_parent()
	self.enemy_laser_shot.connect(p._on_enemy_laser_shot)
	
	movement_vector = (get_node("/root/Game/Player").global_position - global_position).normalized()
	
	health = 3
	shield = 0
	speed = 90
	scale = Vector2(0.4, 0.4)
	
	$Shoot.wait_time = rng.randf_range(1,3)
	$Shoot.start()
	$ShootAlt.wait_time = rng.randf_range(3,5)
	$ShootAlt.start()

func _process(delta: float) -> void:
	super._process(delta)
	$MuzzleMain.position = get_rotated_point($Sprite2D.frame, MuzzleMain_defRot)
	$MuzzleLeft.position = get_rotated_point($Sprite2D.frame, MuzzleLeft_defRot)
	$MuzzleRight.position = get_rotated_point($Sprite2D.frame, MuzzleRight_defRot)
	$MuzzleRight2.position = get_rotated_point($Sprite2D.frame, MuzzleRight2_defRot)
	$MuzzleLeft2.position = get_rotated_point($Sprite2D.frame, MuzzleLeft2_defRot)
	
	$CollisionShape2D.position = get_rotated_point($Sprite2D.frame, CollisionShape_defRot)
	$CollisionShape2D.rotation = movement_vector.angle()
	$CollisionShape2D2.position = get_rotated_point($Sprite2D.frame, CollisionShape2_defRot)
	$CollisionShape2D2.rotation = movement_vector.angle()



func _on_shoot_timeout() -> void:
	shoot_main_laser()
	
	$Shoot.wait_time = rng.randf_range(1,3)
	$Shoot.start()


func _on_shoot_alt_timeout() -> void:
	shoot_side_laser()
	
	$ShootAlt.wait_time = rng.randf_range(3,5)
	$ShootAlt.start()


func _on_area_entered(area: Area2D) -> void:
	if area is Laser:
		if !area.friendly:
			pass
		else:
			take_damage()
			area.queue_free()
	else:
		take_damage()
