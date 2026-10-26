extends Node

const ITEM = preload("uid://co6ml5s0hw0i")

enum ToolType {
	NONE, PICKAXE, AXE, SHOVEL
}

var player: Player

var triggers: Dictionary[Signal, bool]

func spawn_item(stack: ItemStack, pos: Vector3):
	var item: ItemEntity = ITEM.instantiate()
	item.stack = stack
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
