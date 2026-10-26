class_name ResourceNode
extends StaticBody3D

@export var drops: Array[ItemStack]
@export var model: Node3D
@export var hitbox: Area3D
@export var required_tool: Global.ToolType
@export var tool_tier: int
@export var health: int = 3
@export var hit_sound: AudioStream
@export var break_sound: AudioStream

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
