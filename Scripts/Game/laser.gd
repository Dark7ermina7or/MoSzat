class_name Laser
extends Area2D

#var movement_vector := Vector2(1, 0) #Use movement_vector_passed
@export var speed := 200
@export var friendly : bool
@export var isseeker := false
@export var seeker_turn_speed := 2.75
@export var movement_vector_passed : Vector2
var seekerEnd = false

var previous_position = Vector2.ZERO  # Stores the position from the last frame

var explosion_scene = Preloads.explosion

signal shotByPlayer()
signal shotByAI()
signal seeker()

func _process(delta: float) -> void:
	if isseeker:
		#movement_vector_passed = (get_node("/root/Game/Player").global_position - global_position).normalized()
		movement_vector_passed = movement_vector_passed.lerp((get_node("/root/Game/Player").global_position - global_position).normalized(), seeker_turn_speed * delta).normalized()
	global_position += movement_vector_passed * speed * delta
	rotation = movement_vector_passed.angle()
	
	if friendly:
		self.set_collision_mask_value(2, false)
		self.set_collision_mask_value(3, true)
	else:
		self.set_collision_mask_value(2, true)
		self.set_collision_mask_value(3, true)
	
	if seekerEnd:
		# Calculate direction based on position difference
		movement_vector_passed = (global_position - previous_position).normalized()
		# Update previous position
	previous_position = global_position

func _ready() -> void:
	var r = bool(randi() % 2)
	if r:
		AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_laser_shot)
	else:
		AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_laser_shot_alt)
	
	$AnimatedSprite2D.play("loop")
	
	if friendly:
		movement_vector_passed = ((get_global_mouse_position() - global_position).normalized()) 
	
	if isseeker:
		$SeekerTime.wait_time = 2.5
		$SeekerTime.start()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$".".queue_free()


func _on_shot_by_player() -> void:
	friendly = true
	#self.set_collision_mask_value(2, false)
	#self.set_collision_mask_value(3, true)

func _on_shot_by_ai() -> void:
	friendly = false
	#self.set_collision_mask_value(2, true)
	#self.set_collision_mask_value(3, true)


func _on_seeker_time_timeout() -> void:
	isseeker = false # Replace with function body.
	seekerEnd = true

func _on_seeker() -> void:
	isseeker = true
