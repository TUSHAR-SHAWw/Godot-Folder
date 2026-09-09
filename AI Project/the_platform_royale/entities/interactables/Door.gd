class_name Door
extends StaticBody2D

@export var is_open: bool = false
@export var target_floor: int = 1

func toggle_door() -> void:
	is_open = !is_open
	$CollisionShape2D.disabled = is_open
