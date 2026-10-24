class_name ItemEntity
extends RigidBody3D

@export var stack := ItemStack.empty()

func _ready() -> void:
	update()
	
	$Area3D.body_entered.connect(func(body: Node3D):
		if !body is Player: return
		
		var added = body.inventory.add(stack)
		if added: queue_free()
	)
	
func update() -> void:
	if !stack is ItemStack: return
	if stack.is_empty(): return
	
	$Sprite3D.texture = stack.item.texture
