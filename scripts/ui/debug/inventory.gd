extends Control

@export var slot_scene: PackedScene
var slots: Array[Control]

func _ready() -> void:
	for i in range(Global.player.inventory.slots):
		var slot = slot_scene.instantiate()
		$Panel/GridContainer.add_child(slot)
		slots.append(slot)

func _process(_delta: float) -> void:
	for i in range(slots.size()):
		var stack = Global.player.inventory.get_item(i)
		
		if stack.is_empty():
			slots[i].get_node("TextureRect").texture = null
			slots[i].get_node("Label").text = ""
		else:
			slots[i].get_node("TextureRect").texture = stack.item.texture
			slots[i].get_node("Label").text = str(stack.count)
