class_name PlayerDistributor
extends Node

static func distribute_players_across_floors(players: Array, total_floors: int) -> Dictionary:
	var floor_assignments: Dictionary = {}
	for f in range(1, total_floors + 1):
		floor_assignments[f] = []
	
	for p in players:
		var assigned_floor = (randi() % total_floors) + 1
		floor_assignments[assigned_floor].append(p)
		
	return floor_assignments
