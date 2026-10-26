class_name Item
extends Resource

@export var name: String
@export var texture: Texture2D
@export var max_count := 99

@export var tool_type: Global.ToolType
@export var tool_tier := 0

func is_tool(type: Global.ToolType, tier: int) -> bool:
	if tool_type == Global.ToolType.NONE: return false
	return tool_type == type and tool_tier >= tier
