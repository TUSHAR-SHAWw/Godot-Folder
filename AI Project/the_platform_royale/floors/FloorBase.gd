class_name FloorBase
extends Node2D

@export var floor_id: int = 1
@export var floor_type: String = "SimpleFloor"
@export var is_collapsing: bool = false

func _ready() -> void:
	FloorManager.register_floor(self)

func trigger_environmental_effect(body: Node2D) -> void:
	pass

func collapse_floor() -> void:
	is_collapsing = true
	FloorManager.unregister_floor(self)
	queue_free()
