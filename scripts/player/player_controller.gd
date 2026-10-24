extends CharacterBody3D

@export var speed := 5.0
@export var acceleration := 6.0
@export var jump_power := 4.5
@export var sensitivity := 0.015
@export var zoom_step := 0.2
@export var max_zoom := 4.0
var camera_length := 4.0
var first_person := false
var unlock_camera := false

@onready var player_model: PlayerModel = $Model

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and unlock_camera:
		rotation.y -= event.relative.x * sensitivity
		$CameraPivot.rotation.x -= event.relative.y * sensitivity
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, -PI / 4, PI / 4)
		
	if event.is_action_pressed("zoom_in"): camera_length -= zoom_step
	if event.is_action_pressed("zoom_out"): camera_length += zoom_step
	camera_length = clamp(camera_length, 0, max_zoom)
		
	if event.is_action_pressed("pause"): get_tree().quit()

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor(): velocity += get_gravity() * delta
	
	# jumping
	if Input.is_action_just_pressed("jump"): velocity.y = jump_power
	
	# horizontal movement
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
		player_model.play_anim("walk")
	else:
		player_model.play_anim("idle")
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0, acceleration * delta)
	
	# apply the motion
	move_and_slide()

func _process(delta: float) -> void:
	# camera movement
	$CameraPivot.spring_length = move_toward($CameraPivot.spring_length, camera_length, acceleration * delta)
	
	if camera_length > 1: player_model.opacity = 1
	else: player_model.opacity = camera_length / 1
	
	# roblox-style camera controls
	first_person = camera_length == 0
	unlock_camera = first_person or Input.is_action_pressed("rotate_cam")
	
	if unlock_camera: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	$CanvasLayer/Crosshair.visible = first_person
