class_name FloorRules
extends Node

static func get_floors_for_player_count(count: int) -> int:
	return MathUtils.calculate_floor_scaling(count)
