extends Node

var active_floors: Array = []
var total_floor_count: int = 120

func register_floor(floor_node: Node) -> void:
	if not active_floors.has(floor_node):
		active_floors.append(floor_node)

func unregister_floor(floor_node: Node) -> void:
	if active_floors.has(floor_node):
		active_floors.erase(floor_node)

func shrink_floors_to(target_floor_count: int) -> void:
	if target_floor_count >= total_floor_count:
		return
	
	var excess_count = total_floor_count - target_floor_count
	total_floor_count = target_floor_count
	
	print("[FloorManager] Shrinking tower! Removing top ", excess_count, " floors. New total: ", total_floor_count)
	SignalBus.floors_collapsed.emit(excess_count, total_floor_count)
