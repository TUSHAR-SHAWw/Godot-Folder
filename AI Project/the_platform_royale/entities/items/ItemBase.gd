class_name ItemBase
extends Area2D

@export var item_name: String = "Base Item"
@export var item_type: String = "Generic"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") or body.is_in_group("Bots"):
		var inv = body.get_node_or_null("InventoryComponent")
		if inv:
			if inv.add_item({"name": item_name, "type": item_type}):
				queue_free()
