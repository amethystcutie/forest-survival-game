class_name ToolItem
extends Item

enum ToolType {
	NONE, PICKAXE, AXE, SHOVEL
}

@export var tool_type: ToolType = ToolType.NONE
@export var tool_tier := 0

func is_tool(type: ToolType, tier: int) -> bool:
	if tool_type == ToolType.NONE: return false
	return tool_type == type and tool_tier >= tier
	
static func is_this_tool(item: Item, type: ToolType, tier: int) -> bool:
	if type == ToolType.NONE: return true
	if tier <= 0: return true
	if item == null: return false
	if item is not ToolItem: return false
	if item.tool_type == ToolType.NONE: return false
	return item.tool_type == type and item.tool_tier >= tier
