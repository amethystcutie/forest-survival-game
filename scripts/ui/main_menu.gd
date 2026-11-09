extends Node3D

func read_text_file(path: String, message: String = "") -> String:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			return file.get_as_text()
		
	return message

func _ready() -> void:
	if Engine.is_embedded_in_editor():
		$UI/Control/Info/DebugLabel.text = "Embedded in editor"
	elif OS.is_debug_build():
		$UI/Control/Info/DebugLabel.text = "Debug build!!"
	else:
		$UI/Control/Info/DebugLabel.hide()
		
	$UI/Control/Info/VersionLabel.text = ProjectSettings.get_setting("application/config/version")
	
	$UI/Control/Buttons/LoadButton.disabled = true
	$UI/Control/Buttons/NewGameButton.pressed.connect(func():
		SceneManager.change_scene("res://scenes/forest.tscn"))
		
	$UI/Control/Buttons/CreditsButton.pressed.connect(func():
		$UI/AnimationPlayer.play("credits_open"))
		
	$UI/Control/Buttons/QuitButton.pressed.connect(SceneManager.quit_game)
	
	$UI/CreditsMenu/MarginContainer/VBoxContainer/Header/Button.pressed.connect(func():
		$UI/AnimationPlayer.play("credits_close"))
		
	$UI/CreditsMenu/MarginContainer/VBoxContainer/ScrollContainer/MarkdownLabel.text = read_text_file("res://LICENSE.md", "Couldn't find license text")
