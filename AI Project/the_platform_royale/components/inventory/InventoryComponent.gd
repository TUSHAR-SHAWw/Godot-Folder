class_name InventoryComponent
extends Node

@export var max_slots: int = 10
var items: Array = []

func add_item(item_data: Dictionary) -> bool:
	if items.size() < max_slots:
		items.append(item_data)
		SignalBus.item_looted.emit(owner, item_data)
		return true
	return false

func remove_item(index: int) -> Dictionary:
	if index >= 0 and index < items.size():
		var item = items[index]
		items.remove_at(index)
		return item
	return {}
