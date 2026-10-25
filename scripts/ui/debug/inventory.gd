extends Control

@export var slot_scene: PackedScene
var slots: Array[Control]

var mouse_item := ItemStack.empty()

func _ready() -> void:
	for i in range(Global.player.inventory.slots):
		var slot = slot_scene.instantiate()
		$Panel/GridContainer.add_child(slot)
		slots.append(slot)
		slot.pressed.connect(func():
			var slot_item = Global.player.inventory.get_item(i)
			if slot_item.item == mouse_item.item:
				var space_left = slot_item.item.max_count - slot_item.count
				var to_add = min(mouse_item.count, space_left)
				var leftover = mouse_item.count - to_add
				
				Global.player.inventory.items[i].count += to_add
				
				if leftover > 0:
					mouse_item.count = leftover
				else:
					mouse_item = ItemStack.empty()
			else:
				Global.player.inventory.set_item(i, mouse_item)
				mouse_item = slot_item
		)

func _process(_delta: float) -> void:
	if mouse_item.is_empty():
		$MouseItem/TextureRect.texture = null
		$MouseItem/Label.text = ""
		$MouseItem.set_position(Vector2.ZERO, true)
	else:
		$MouseItem/TextureRect.texture = mouse_item.item.texture
		$MouseItem/Label.text = str(mouse_item.count)
		$MouseItem.set_global_position(get_global_mouse_position(), true)
	
	for i in range(slots.size()):
		var stack = Global.player.inventory.get_item(i)
		
		if stack.is_empty():
			slots[i].get_node("TextureRect").texture = null
			slots[i].get_node("Label").text = ""
		else:
			slots[i].get_node("TextureRect").texture = stack.item.texture
			slots[i].get_node("Label").text = str(stack.count)
