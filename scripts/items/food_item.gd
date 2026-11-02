class_name FoodItem
extends Item

@export var food_value := 10
@export var anim := UseAnim.EAT

func _init() -> void:
	use_anim = anim
	usable = true

func use(player: Player, stack: ItemStack) -> void:
	super.use(player, stack)
	player.feed(food_value)
