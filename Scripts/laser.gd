class_name Laser
extends Area2D

var movement_vector := Vector2(1, 0)
@export var speed := 200
@export var friendly : bool

signal shotByPlayer()
signal shotByAI()

func _process(delta: float) -> void:
	global_position += movement_vector * speed * delta

func _ready() -> void:
	$AnimatedSprite2D.play("loop")
	movement_vector = (get_global_mouse_position() - global_position).normalized()
	rotation = movement_vector.angle()
	
	#if friendly:
		#self.set_collision_mask_value(2, false)
		#self.set_collision_mask_value(3, true)
	#else:
		#self.set_collision_mask_value(2, true)
		#self.set_collision_mask_value(3, false)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$".".queue_free()


func _on_shot_by_player() -> void:
	friendly = true
	self.set_collision_mask_value(2, false)
	self.set_collision_mask_value(3, true)


func _on_shot_by_ai() -> void:
	friendly = false
	self.set_collision_mask_value(2, true)
	self.set_collision_mask_value(3, true)
