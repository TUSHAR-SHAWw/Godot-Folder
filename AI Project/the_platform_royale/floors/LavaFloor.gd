class_name LavaFloor
extends FloorBase

func _init() -> void:
	floor_type = "LavaFloor"

override func trigger_environmental_effect(body: Node2D) -> void:
	var hp_comp = body.get_node_or_null("HealthComponent")
	if hp_comp:
		hp_comp.take_damage(10.0) # Fire hazard tick
