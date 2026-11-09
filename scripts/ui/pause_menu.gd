extends CanvasLayer

func _ready() -> void:
	hide()
	
	$Control/Panel/MarginContainer/VBoxContainer/ResumeButton.pressed.connect(
		unpause)
	$Control/Panel/MarginContainer/VBoxContainer/OptionsButton
	$Control/Panel/MarginContainer/VBoxContainer/MainMenuButton.pressed.connect(func():
		unpause()
		SceneManager.change_scene("res://scenes/ui/main_menu.tscn"))
	
	$Control/Panel/MarginContainer/VBoxContainer/QuitButton.visible = Engine.is_embedded_in_editor()
	$Control/Panel/MarginContainer/VBoxContainer/QuitButton.pressed.connect(
		get_tree().quit)

func pause() -> void:
	Engine.time_scale = 0.0
	Global.unpause.emit()
	Global.paused = true
	show()
	
func unpause() -> void:
	Engine.time_scale = 1.0
	Global.unpause.emit()
	Global.paused = false
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if Global.paused:
			unpause()
		else:
			pause()
