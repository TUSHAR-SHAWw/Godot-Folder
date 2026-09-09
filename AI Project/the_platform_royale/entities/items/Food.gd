class_name Food
extends ItemBase

@export var hunger_restore_amount: float = 30.0

func _init() -> void:
	item_type = "Food"

override func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") or body.is_in_group("Bots"):
		var hunger_comp = body.get_node_or_null("HungerComponent")
		if hunger_comp:
			hunger_comp.consume_food(hunger_restore_amount)
			queue_free()
