class_name Item
extends Resource

@export var name: String
@export var texture: Texture2D
@export var max_count := 99
@export var handle_offset := Vector2(0.5, 0.0)

@export var tool_type: Global.ToolType = Global.ToolType.NONE
@export var tool_tier := 0
@export var use_time := 1
@export var swing_anim := 1

func is_tool(type: Global.ToolType, tier: int) -> bool:
	if tool_type == Global.ToolType.NONE: return false
	return tool_type == type and tool_tier >= tier
	
static func is_this_tool(item: Item, type: Global.ToolType, tier: int) -> bool:
	if type == Global.ToolType.NONE: return true
	if tier <= 0: return true
	if item == null: return false
	if item.tool_type == Global.ToolType.NONE: return false
	return item.tool_type == type and item.tool_tier >= tier

func get_handle_offset() -> Vector2:
	return Vector2(handle_offset.y, handle_offset.x) * texture.get_size()
	
