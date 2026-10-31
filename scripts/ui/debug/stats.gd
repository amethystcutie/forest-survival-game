extends Control

@onready var health_bar: ProgressBar = $Panel/MarginContainer/GridContainer/HealthBar
@onready var hunger_bar: ProgressBar = $Panel/MarginContainer/GridContainer/HungerBar

func _ready() -> void:
	await Global.player_ready
	health_bar.max_value = Global.player.max_health
	hunger_bar.max_value = Global.player.max_hunger

func _process(_delta: float) -> void:
	health_bar.value = Global.player.health
	hunger_bar.value = Global.player.hunger
