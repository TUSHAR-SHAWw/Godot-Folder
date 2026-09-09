class_name WaterFloor
extends FloorBase

func _init() -> void:
	floor_type = "WaterFloor"

override func trigger_environmental_effect(body: Node2D) -> void:
	var move_comp = body.get_node_or_null("MovementComponent")
	if move_comp:
		move_comp.speed_multiplier = 0.6 # Water slow effect
