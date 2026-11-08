extends AudioStreamPlayer

func _ready() -> void:
	if !Engine.is_embedded_in_editor():
		play()
		finished.connect(func(): play())
