class_name FloorGenerator
extends Node

static func generate_tower_structure(count: int) -> Array:
	var floors: Array = []
	var pool = [
		"SimpleFloor", "ForestFloor", "WaterFloor", "CaveFloor",
		"LavaFloor", "ToxicFloor", "IceFloor",
		"ArmoryFloor", "FeastFloor", "MedicalFloor", "GoldenFloor"
	]
	
	for i in range(count):
		var selected_type = pool[randi() % pool.size()]
		floors.append({
			"floor_index": i + 1,
			"type": selected_type
		})
	return floors
