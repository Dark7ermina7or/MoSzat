extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_title("MoSzat")
	DisplayServer.window_set_size(Vector2i(1280,720))
	DisplayServer.window_set_position(Vector2i((DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2),0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
