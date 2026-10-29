class_name ResourceNode
extends StaticBody3D

@export var drops: Array[ItemStack]
@export var model: Node3D
@export var hitbox: Area3D
@export var collider: CollisionShape3D
@export var required_tool: Global.ToolType
@export var tool_tier: int
@export var max_health: int = 3
@export var hit_sound: AudioStream
@export var break_sound: AudioStream

@export_category("Respawning")
@export var respawns := true
@export var min_respawn_time := 120.0
@export var max_respawn_time := 300.0
@export var lives := -1

@onready var health: int = max_health
var depleted := false
var player: Player

var hit := false

func _ready() -> void:
	hitbox.body_entered.connect(on_hitbox_enter)
	hitbox.body_exited.connect(on_hitbox_leave)

func on_hitbox_enter(body: Node3D) -> void:
	print(body.name)
	if body is Player: 
		player = body
		player.swing.connect(on_player_hit)
	
func on_hitbox_leave(body: Node3D) -> void:
	print(body.name)
	if body == player:
		player.swing.disconnect(on_player_hit)
		player = null

func on_player_hit(tool: Item) -> void:
	if depleted: return
	if Item.is_this_tool(tool, required_tool, tool_tier):
		health -= 1
		AudioManager.play_3d(hit_sound, global_position)
		if health <= 0:
			for stack in drops:
				Global.spawn_item(stack, global_position + Vector3(
					randf() - 0.5, 1.0, randf() - 0.5
				))
			
			if respawns:
				lives -= 1
				depleted = true
				collider.set_deferred("disabled", true)
				
				if lives == 0: respawns = false
				get_tree().create_timer(randf_range(min_respawn_time, max_respawn_time)).timeout.connect(func():
					depleted = false
					health = max_health
					collider.set_deferred("disabled", false))
			else:
				queue_free()
		else:
			hit = true
		get_tree().create_timer(0.1).timeout.connect(func():
			hit = false)
