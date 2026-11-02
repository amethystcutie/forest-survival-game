class_name Item
extends Resource

enum UseAnim {
	NONE,
	PUNCH,
	SWING,
	CHOP,
	EAT
}

@export var name: String
@export var texture: Texture2D
@export var max_count := 99
@export var handle_offset := Vector2(0.5, 0.0)

@export var use_time := 1.5
@export var swing_anim := UseAnim.SWING
@export var use_anim := UseAnim.NONE

@export var usable = false

func get_handle_offset() -> Vector2:
	return Vector2(handle_offset.y, handle_offset.x) * texture.get_size()

func use(player: Player, stack: ItemStack) -> void: 
	pass

func swing(player: Player, stack: ItemStack) -> void:
	pass
