class_name RoundSystem
extends Node

static func evaluate_round_progression(alive_players: int) -> int:
	return MathUtils.calculate_floor_scaling(alive_players)
