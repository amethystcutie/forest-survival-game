extends AudioStreamPlayer

func _ready() -> void:
	play()
	finished.connect(func(): play())
