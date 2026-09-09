class_name MathUtils
extends Node

static func calculate_floor_scaling(alive_players: int) -> int:
	# Rule:
	# 100 players -> 120 floors
	# 70 players -> 85 floors
	# 40 players -> 50 floors
	# 10 players -> 15 floors
	if alive_players >= 70:
		return int(remap(alive_players, 70, 100, 85, 120))
	elif alive_players >= 40:
		return int(remap(alive_players, 40, 70, 50, 85))
	elif alive_players >= 10:
		return int(remap(alive_players, 10, 40, 15, 50))
	else:
		return max(5, int(alive_players * 1.5))

static func remap(val: float, in_min: float, in_max: float, out_min: float, out_max: float) -> float:
	return out_min + (val - in_min) * (out_max - out_min) / (in_max - in_min)
