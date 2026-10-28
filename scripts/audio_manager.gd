extends Node

func play_global(stream: AudioStream) -> void:
	if stream == null: return
	var player = AudioStreamPlayer.new()
	get_tree().root.add_child(player)
	player.stream = stream
	player.play()
	player.finished.connect(func(): player.queue_free())
	
func play_2d(stream: AudioStream, pos: Vector2) -> void:
	if stream == null: return
	var player = AudioStreamPlayer2D.new()
	get_tree().root.add_child(player)
	player.global_position = pos
	player.stream = stream
	player.play()
	player.finished.connect(func(): player.queue_free())
	
func play_3d(stream: AudioStream, pos: Vector3) -> void:
	if stream == null: return
	var player = AudioStreamPlayer3D.new()
	get_tree().root.add_child(player)
	player.global_position = pos
	player.stream = stream
	player.play()
	player.finished.connect(func(): player.queue_free())
	
