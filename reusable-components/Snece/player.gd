class_name player
extends CharacterBody2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var health_com: health_component = $HeathComponent

func _ready() -> void:
	health_com.health_changed.connect(update_health)
	progress_bar.value=health_com.health


func update_health(new_health: int) -> void:
	progress_bar.value=new_health

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("damage"):
		health_com.take_damage(20)
	if event.is_action_pressed("heal"):
		health_com.take_health(20)
	if event.is_action_pressed("health"):
		pass
