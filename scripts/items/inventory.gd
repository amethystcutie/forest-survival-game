class_name Inventory
extends Resource

@export var slots: int = 24
const slots_per_row: int = 8

@export var items: Dictionary[int, ItemStack]

func is_full() -> bool:
	return items.size() >= slots
	
func add(stack: ItemStack) -> bool:
	print(stack)
	print(stack.count)
	print(stack.item)
	
	if stack.is_empty(): return true
	
	print("not empty")
	
	for i in range(slots):
		if !items.keys().has(i):
			items[i] = stack
			print("added at missing slot ", i)
			return true
			
		if !items[i] is ItemStack: 
			print(i, " is not an item stack")
			continue
		
		if items[i].item == stack.item && items[i].count < stack.item.max_count:
			print(i, " has an available stack of the item!")
			
			var space_left = stack.item.max_count - items[i].count
			var to_add = min(stack.count, space_left)
			var leftover = stack.count - to_add
			
			items[i].count += to_add
			print("merged stacks!")
			
			if leftover > 0:
				print(i, " would overflow, so adding only some")
				add(ItemStack.init(stack.item, leftover))
				
			return true
		
		if items[i].is_empty():
			print("found an empty slot at ", i)
			items[i] = stack
			return true
	
	return false

func set_item(id: int, stack: ItemStack) -> void:
	items[id] = stack

func get_item(id: int) -> ItemStack:
	if !items.keys().has(id): return ItemStack.empty()
	return items[id]
