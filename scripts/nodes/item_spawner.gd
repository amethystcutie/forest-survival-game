extends Marker3D

@export var stack: ItemStack
@export var time := 1.0
@export var random_offset := 0.5

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = time
	add_child(timer)
	
	timer.timeout.connect(func():
		var pos = global_position
		
		Global.spawn_item(stack, pos))
	
	timer.start()
