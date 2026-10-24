class_name ItemStack
extends Resource

@export var item: Item
@export var count: int = 1

func is_empty() -> bool:
	return item == null or count < 1

static func empty() -> ItemStack:
	return ItemStack.init(null, 0)

static func of(_item: Item) -> ItemStack:
	return ItemStack.init(_item, 1)

static func init(_item: Item, _count: int) -> ItemStack:
	var stack = ItemStack.new()
	
	stack.item = _item
	stack.count = _count
	
	return stack
