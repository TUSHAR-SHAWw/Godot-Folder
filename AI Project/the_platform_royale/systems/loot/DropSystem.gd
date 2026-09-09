class_name DropSystem
extends Node

static func drop_loot_on_death(entity: Node, location: Vector2) -> Array:
	var dropped_items: Array = []
	var inv = entity.get_node_or_null("InventoryComponent")
	if inv:
		for item in inv.items:
			dropped_items.append(item)
		inv.items.clear()
	return dropped_items
