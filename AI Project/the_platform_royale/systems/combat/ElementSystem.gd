class_name ElementSystem
extends Node

static func apply_elemental_effect(target: Node, element: String) -> void:
	var status_comp = target.get_node_or_null("StatusEffectComponent")
	if status_comp == null:
		return
	
	match element:
		"Fire":
			status_comp.apply_effect("Burn", 4.0)
		"Ice":
			status_comp.apply_effect("Freeze", 2.0)
		"Poison":
			status_comp.apply_effect("Poison", 6.0)
		"Lightning":
			status_comp.apply_effect("Stun", 0.5)
		"Shadow":
			status_comp.apply_effect("Fear", 2.0)
