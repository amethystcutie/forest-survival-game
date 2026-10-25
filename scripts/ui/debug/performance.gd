extends Control

func _process(_delta: float) -> void:
	$Panel/VBoxContainer/FPS.text = "FPS: " + str(int(Engine.get_frames_per_second()))
	
	$Panel/VBoxContainer/BoredTime.text = "Bored for " + str(Global.player.bored_time)
