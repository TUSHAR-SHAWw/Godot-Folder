class_name LootBox
extends Area2D

@export var is_opened: bool = false
@export var floor_type: String = "SimpleFloor"

func open_box(opener: Node2D) -> Array:
	if is_opened:
		return []
	
	is_opened = true
	var loot = LootManager.generate_floor_loot(floor_type)
	var inv = opener.get_node_or_null("InventoryComponent")
	if inv:
		for item in loot:
			inv.add_item(item)
	return loot
