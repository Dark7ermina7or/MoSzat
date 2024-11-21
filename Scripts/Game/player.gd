extends CharacterBody2D

@export var acceleration := 150
@export var max_speed := 500

var laser_scene = Preloads.scene_laser
var MuzzleMain_defRot := Vector2(26,0)

signal laser_shot(laser)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_shoot"):
		shoot_laser()

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	velocity = acceleration * input_direction
	velocity = velocity.limit_length(max_speed)
	
	set_rotated_frame()
	$MuzzleMain.position = get_rotated_point($Sprite2D.frame, MuzzleMain_defRot)
	move_and_slide()

func _ready() -> void:
	MuzzleMain_defRot = $MuzzleMain.position

func _ontt() -> void:
	var ll = laser_scene.instantiate()
	ll.global_position = Vector2(randi_range(0,500),randi_range(0,500))
	ll.emit_signal("shotByAI")
	emit_signal("laser_shot", ll)

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
	emit_signal("laser_shot", l)
