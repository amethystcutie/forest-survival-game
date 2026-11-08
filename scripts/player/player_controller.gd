class_name Player
extends CharacterBody3D

@export var walk_speed := 5.0
@export var run_speed := 8.0
@export var acceleration := 12.0
@export var jump_power := 4.5
@export var sensitivity := 0.015
@export var zoom_step := 0.5
@export var max_zoom := 4.0
@export var inventory: Inventory
@export var spawn_point: Marker3D

@onready var speed := walk_speed

var swing_anim := Item.UseAnim.NONE

var bored_time: float = 0

var camera_length := 4.0
var first_person := false
var unlock_camera := true
var opacity: float

var selected_slot: int = 0

var held_item := ItemStack.empty()
var item_cd := 0.4

@export var max_health := 100
@export var max_hunger := 100

@onready var health := max_health
@onready var hunger := max_hunger

var swing_cooldown := false
var use_cooldown := false
signal swing(item: Item)
signal use(item: Item)

var swing_pressed := false
var use_pressed := false

var dead := false

var running := false

@onready var effect_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

func feed(amount: int) -> void:
	hunger += amount
	if hunger > max_hunger:
		hunger = max_hunger
		
func hurt(amount: int) -> void:
	if dead: return
	
	if amount < 0:
		heal(-amount)
		return
		
	health -= amount
	effect_player.play("hurt")
	if health <= 0:
		die()
		
func heal(amount: int) -> void:
	if dead: return
	
	if amount < 0:
		hurt(-amount)
		return
	
	health += amount
	if health > max_health:
		health = max_health
		effect_player.play("heal")
		
func die() -> void:
	dead = true
	
	effect_player.play("fade_out")
	await effect_player.animation_finished
	
	var death_pos := global_position
	
	global_position = spawn_point.global_position
	
	for i in inventory.items:
		Global.spawn_item(inventory.get_item(i), death_pos + Vector3.UP)
		
	inventory.items.clear()
	
	health = max_health
	hunger = max_hunger
	
	effect_player.play("fade_in")
	
	dead = false
		
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.player = self
	
	global_position = spawn_point.global_position
	effect_player.play("fade_in")
	
	Global.player_ready.emit()
	
	$HungerTimer.timeout.connect(func():
		if hunger >= 1:
			if velocity.length() > 0.2:
				if running:
					hunger -= 6
				else:
					hunger -= 3
			else:
				hunger -= 1
		else:
			hurt(5))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and unlock_camera:
		$CameraPivot.rotation.y -= event.relative.x * sensitivity
		$CameraPivot.rotation.x -= event.relative.y * sensitivity
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, -PI / 4, PI / 4)
		
	if event.is_action_pressed("zoom_in"): camera_length -= zoom_step
	if event.is_action_pressed("zoom_out"): camera_length += zoom_step
	camera_length = clamp(camera_length, 0, max_zoom)
		
	if event.is_action_pressed("pause"): get_tree().quit()

	if event.as_text().to_int() in range(1, 8):
		selected_slot = event.as_text().to_int() - 1
		
	if event.is_action_pressed("hotbar_right"):
		selected_slot += 1
		if selected_slot > 7: selected_slot = 0
	if event.is_action_pressed("hotbar_left"):
		selected_slot -= 1
		if selected_slot < 0: selected_slot = 7
			
		
	if event.is_action_pressed("inventory"):
		unlock_camera = !unlock_camera

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor(): velocity += get_gravity() * delta
	
	# jumping
	if Input.is_action_just_pressed("jump") and is_on_floor(): 
		bored_time = 0
		velocity.y = jump_power
	
	# horizontal movement
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	var direction := (transform.basis.rotated(Vector3.UP, $CameraPivot.rotation.y) * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	running = Input.is_action_pressed("run")
	speed = run_speed if running else walk_speed
	
	if direction and not dead:
		bored_time = 0
		update_model_rotation(delta)
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
	else:
		bored_time += delta
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0, acceleration * delta)
	
	# apply the motion
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("swing"):
		swing_pressed = true
	if event.is_action_pressed("use"):
		use_pressed = true
	if event.is_action_released("swing"):
		swing_pressed = false
	if event.is_action_released("use"):
		use_pressed = false

func _process(delta: float) -> void:
	# camera movement
	$CameraPivot.spring_length = move_toward($CameraPivot.spring_length, camera_length, acceleration * delta)
	
	if camera_length > 1: opacity = 1
	else: opacity = move_toward(opacity, camera_length / 1, delta * 3)
	
	# camera controls
	first_person = camera_length == 0
	
	if unlock_camera: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	$CanvasLayer/Crosshair.visible = first_person
	
	if first_person: update_model_rotation(delta)
	
	$Model/witch/GeneralSkeleton/ChibiWitch.transparency = 1.0 - opacity
	
	held_item = inventory.get_item(selected_slot)
	item_cd = 1.0
	
	if held_item.is_empty():
		$RightHand/Sprite3D.texture = null
	else:
		item_cd = held_item.item.use_time
		$RightHand/Sprite3D.texture = held_item.item.texture
		$RightHand/Sprite3D.offset = held_item.item.get_handle_offset()
	
	if swing_pressed and !swing_cooldown and !use_cooldown:
		bored_time = 0.0
		swing_cooldown = true
		get_tree().create_timer(item_cd).timeout.connect(func():
			swing_cooldown = false
			print(swing_cooldown))
		
		if !held_item.is_empty(): swing_anim = held_item.item.swing_anim
		else: swing_anim = Item.UseAnim.PUNCH
		
		get_tree().create_timer(item_cd / 3).timeout.connect(func(): 
			swing.emit(held_item.item) 
			swing_anim = Item.UseAnim.NONE)
			
		print(swing_anim)
		
		
	if use_pressed and !use_cooldown and held_item.usable():
		bored_time = 0.0
		use_cooldown = true
		get_tree().create_timer(item_cd).timeout.connect(func():
			use_cooldown = false
			swing_anim = Item.UseAnim.NONE)
			
		if !held_item.is_empty(): swing_anim = held_item.item.get_use_anim()
		get_tree().create_timer(item_cd / 3).timeout.connect(func(): 
			held_item.item.use(self, held_item)
			use.emit(held_item.item))
	
func update_model_rotation(delta: float):
	$Model.rotation.y = rotate_toward($Model.rotation.y, $CameraPivot.rotation.y, acceleration * delta)
