extends Node

const ITEM = preload("uid://co6ml5s0hw0i")

var player: Player
var environment: EnvironmentManager

var paused := false
signal pause
signal unpause

signal player_ready
var triggers: Dictionary[Signal, bool]

func spawn_item(stack: ItemStack, pos: Vector3):
	var item: ItemEntity = ITEM.instantiate()
	item.stack = stack.copy()
	item.global_position = pos
	get_tree().root.add_child(item)

func on_trigger(trigger: Signal) -> bool:
	if trigger not in triggers:
		trigger.connect(func():
			print("triggered", trigger.get_name())
			triggers[trigger] = true)
		return false
			
	if triggers[trigger]: 
		triggers[trigger] = false
		return true
		
	return false

func _ready() -> void:
	if !Engine.is_embedded_in_editor():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	GameSettings.update_settings.connect(on_update_settings)
	on_update_settings()

func on_update_settings() -> void:
	var theme = preload("uid://71fle6rpettp")
	
	if GameSettings.legible_font:
		theme.default_font = preload("uid://cj3uh5h8ncj0k")
	else:
		theme.default_font = preload("uid://dyyvjio5ta25r")
	
	get_tree().root.theme = theme
