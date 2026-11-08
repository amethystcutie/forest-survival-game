class_name FoodItem
extends Item

@export var food_value := 10
@export var anim := UseAnim.EAT

func _init() -> void:
	usable = true

func use(player: Player, stack: ItemStack) -> void:
	super.use(player, stack)
	player.feed(food_value)
	stack.subtract(1)

func get_use_anim() -> UseAnim:
	return anim
