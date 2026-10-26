extends Node

const ITEM = preload("uid://co6ml5s0hw0i")

enum ToolType {
	NONE, PICKAXE, AXE, SHOVEL
}

var player: Player

func spawn_item(stack: ItemStack, pos: Vector3):
	var item: ItemEntity = ITEM.instantiate()
	item.stack = stack
	item.global_position = pos
	get_tree().root.add_child(item)
