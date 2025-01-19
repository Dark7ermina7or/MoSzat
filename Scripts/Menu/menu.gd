extends Control

var focusFlag = true
var highscore = ConfigFileHandler.load_score_settings()

#
# https://www.youtube.com/watch?v=Mx3iyz8AUAE
#

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	focusFlag = true
	$MarginContainer/VBoxContainer/Start.grab_focus()
	AudioStreamPlayerGlobal.play_music(Preloads.music)
	
	var shaderMat = $ColorRect_Shader.material as ShaderMaterial
	shaderMat.set_shader_parameter("resolution", DisplayServer.window_get_size()/2)
	
	$MarginContainer/VBoxContainer2/Score.text = "High Score: " + str(highscore)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		#focusFlag = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		focusFlag = true
	#pass


func _on_start_pressed() -> void:
	AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)
	SceneTransition.scene_transition("res://Scenes/Game/Game.tscn")


func _on_options_pressed() -> void:
	AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)
	#get_tree().change_scene_to_file("res://Scenes/settings_menu.tscn")
	SceneTransition.scene_transition("res://Scenes/Menu/settings_menu.tscn")


func _on_bestiary_pressed() -> void:
	AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)
	get_tree().quit()



func _on_button_focus_entered() -> void:
	if focusFlag:
		focusFlag = false
	else:
		AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)


#func _on_button_mouse_entered() -> void:
	##focusFlag = true
	#AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)


#func _on_button_mouse_exited() -> void:
	#focusFlag = false


func _on_start_mouse_entered() -> void:
	$MarginContainer/VBoxContainer/Start.grab_focus()

func _on_bestiary_mouse_entered() -> void:
	$MarginContainer/VBoxContainer/Bestiary.grab_focus()

func _on_options_mouse_entered() -> void:
	$MarginContainer/VBoxContainer/Options.grab_focus()

func _on_exit_mouse_entered() -> void:
	$MarginContainer/VBoxContainer/Exit.grab_focus()
