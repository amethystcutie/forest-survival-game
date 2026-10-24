class_name PlayerModel
extends Node3D

@export var opacity := 1.0
@export var animation := "idle"
var anim_paused := false

func play_anim(anim: String):
	animation = anim
	resume_anim()
	
func pause_anim(): anim_paused = true
func resume_anim(): anim_paused = false

func get_anim_name() -> String:
	return animation
