extends Node

func change_scene(path: String, action: Callable = func(): pass) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$CanvasLayer/AnimationPlayer.play("fade_out")
	await $CanvasLayer/AnimationPlayer.animation_finished
	action.call()
	get_tree().change_scene_to_file(path)
	await get_tree().scene_changed
	$CanvasLayer/AnimationPlayer.play("fade_in")
	await $CanvasLayer/AnimationPlayer.animation_finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func quit_game() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$CanvasLayer/AnimationPlayer.play("fade_out")
	await $CanvasLayer/AnimationPlayer.animation_finished
	get_tree().quit()
