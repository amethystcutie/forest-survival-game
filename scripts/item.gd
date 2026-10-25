class_name ItemEntity
extends RigidBody3D

@export var stack := ItemStack.empty()

var player: Player

func _ready() -> void:
	$Sprite3D.texture = null
	update()
	
	$Area3D.body_entered.connect(func(body: Node3D):
		if body is Player: player = body
	)
	
func update() -> void:
	if !stack is ItemStack: return
	if stack.is_empty(): return
	
	$Sprite3D.texture = stack.item.texture

func _physics_process(_delta: float) -> void:
	if not player: return
	
	freeze = true
	global_position = lerp(global_position, player.global_position, 0.2)

	if global_position.distance_to(player.global_position) < 0.2:
		var added = player.inventory.add(stack)
		if added: 
			queue_free() 
		else:
			player = null
			freeze = false
