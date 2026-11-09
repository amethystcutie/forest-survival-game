extends MusicPlayer

@export var playlist: Dictionary[TimeManager.DayTime, PlaylistResource]
@export var current_track := 0

func _get_current_track() -> AudioStream:
	return playlist[TimeManager.time_of_day].tracks[current_track]
	
func _on_finish() -> void:
	current_track += 1
	if current_track >= playlist.size():
		current_track = 0

func _ready() -> void:
	super._ready()
	TimeManager.time_advance.connect(func(_time: TimeManager.DayTime): 
		current_track = 0
		next())
