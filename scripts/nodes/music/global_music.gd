extends MusicPlayer

@export var playlist: PlaylistResource
@export var current_track := 0

func _get_current_track() -> AudioStream:
	return playlist.tracks[current_track]
	
func _on_finish() -> void:
	current_track += 1
	if current_track >= playlist.size():
		current_track = 0
