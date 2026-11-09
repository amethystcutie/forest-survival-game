@abstract
class_name MusicPlayer
extends AudioStreamPlayer

@export var fade_time := 0.2
@onready var base_volume := volume_linear

func _ready() -> void:
	if Engine.is_embedded_in_editor(): return
	
	next()
	finished.connect(func():
		_on_finish()
		next())

@abstract func _get_current_track() -> AudioStream
@abstract func _on_finish() -> void

func next() -> void:
	stop()
	stream = _get_current_track()
	play()

func _process(_delta: float) -> void:
	if get_playback_position() < fade_time:
		volume_linear = move_toward(0.0, base_volume, get_playback_position() / fade_time)
	elif get_playback_position() > stream.get_length() - fade_time:
		volume_linear = move_toward(base_volume, 0.0, (stream.get_length() - get_playback_position()) / fade_time)
