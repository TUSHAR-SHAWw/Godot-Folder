class_name InventoryUI
extends Control

@export var is_open: bool = false

func toggle_inventory() -> void:
	is_open = !is_open
	visible = is_open
