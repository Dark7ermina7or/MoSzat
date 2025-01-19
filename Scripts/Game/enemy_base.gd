class_name Enemy_Base 
extends Area2D

@export var health = 1
@export var shield = 0

var explosion_scene = Preloads.explosion
var laser_scene = Preloads.scene_laser
var movement_vector := Vector2(1, 0)

var previous_position = Vector2.ZERO  # Stores the position from the last frame
@export var speed := 200

signal enemy_laser_shot(laser) #Has to be manually connected in each enemy _ready()
#signal seeker(laser)
signal seeker()

func _ready() -> void:
	set_collision_layer(0x0)
	set_collision_layer_value(3, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, true)

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

func spawn_explosion():
	var e = explosion_scene.instantiate()
	e.global_position = self.global_position
	get_parent().add_child(e)

func take_damage():
	if shield <= 0:
		health = health - 1
	else:
		shield = shield - 1
	
	if health <= 0:
		spawn_explosion()
		get_parent().player.score += 1
		queue_free()
