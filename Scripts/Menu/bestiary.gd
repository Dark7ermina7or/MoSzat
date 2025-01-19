extends Control

var unlocked = {}
var names = []
var index = 0

signal indexChanged()

func _ready() -> void:
	FOCUS_NONE
	
	unlocked = ConfigFileHandler.load_progress_settings()
	for key in unlocked.keys():
		names.append(key)
	
	emit_signal("indexChanged")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)
		SceneTransition.scene_transition("res://Scenes/Menu/menu.tscn")
	if Input.is_action_just_pressed("ui_left"):
		AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)
		_on_prev_pressed()
	if Input.is_action_just_pressed("ui_right"):
		AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)
		_on_next_pressed()

func _on_back_pressed() -> void:
	AudioStreamPlayerGlobal.play_SFX(Preloads.sfx_gui_conf)
	SceneTransition.scene_transition("res://Scenes/Menu/menu.tscn")


func _on_prev_pressed() -> void:
	index = index - 1
	if index < 0:
		index = unlocked.size() - 1
	emit_signal("indexChanged")


func _on_next_pressed() -> void:
	index = index + 1
	if index > unlocked.size() - 1:
		index = 0
	emit_signal("indexChanged")


func _on_index_changed() -> void:
	if unlocked.get(str(names[index])):
		$MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/Label.text = str(names[index]).to_upper()
		$MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/EnemyHolder/Enemy.play(str(names[index]))
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/Label.text = "CLASSIFIED"
		$MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/EnemyHolder/Enemy.play("classified")
