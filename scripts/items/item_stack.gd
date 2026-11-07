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

func copy() -> ItemStack:
	return ItemStack.init(item, count)

static func init(_item: Item, _count: int) -> ItemStack:
	var stack = ItemStack.new()
	
	stack.item = _item
	stack.count = _count
	
	return stack

func add(amount: int) -> bool:
	count += amount
	return count <= item.max_count
	
func subtract(amount: int) -> bool:
	count -= amount
	if amount <= 0:
		item = null
	return count > 0

func can_add(amount: int) -> bool:
	return count + amount <= item.max_count
	
func can_subtract(amount: int) -> bool:
	return count - amount > 0

func usable() -> bool:
	if is_empty(): return false
	return item.usable
