class_name LootTable
extends Node

static func get_table_for_floor(floor_name: String) -> Array:
	return LootManager.generate_floor_loot(floor_name)
