extends Control

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var hunger_bar: TextureProgressBar = $HungerBar

func _ready() -> void:
	await Global.player_ready
	health_bar.max_value = Global.player.max_health
	hunger_bar.max_value = Global.player.max_hunger

func _process(_delta: float) -> void:
	health_bar.value = move_toward(health_bar.value, Global.player.health, 0.1)
	hunger_bar.value = move_toward(hunger_bar.value, Global.player.hunger, 0.1)
