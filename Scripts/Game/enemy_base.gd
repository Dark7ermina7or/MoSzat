class_name Enemy_Base 
extends Area2D

var laser_scene = Preloads.scene_laser
var movement_vector := Vector2(1, 0)

var previous_position = Vector2.ZERO  # Stores the position from the last frame
@export var speed := 200

signal enemy_laser_shot(laser) #Has to be manually connected in each enemy _ready()
#signal seeker(laser)
signal seeker()

func _process(delta: float) -> void:
	#movement_vector = (get_node("/root/Game/Player").global_position - global_position).normalized()
	global_position += movement_vector * speed * delta
	set_rotated_frame()

func set_rotated_frame():
	# Calculate direction based on position difference
	var direction = (global_position - previous_position).normalized()
	# Update previous position
	previous_position = global_position
	
	#var direction = get_global_mouse_position() - global_position
	var angle_degrees = rad_to_deg(direction.angle())

	if angle_degrees < 0:
		angle_degrees += 360

	angle_degrees = int (angle_degrees + 11.25) % 360

	var frame_index = int((angle_degrees / 360.0) * $Sprite2D.hframes)
	$Sprite2D.frame = frame_index % $Sprite2D.hframes
