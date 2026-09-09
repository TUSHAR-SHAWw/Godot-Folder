class_name CraftingComponent
extends Node

func craft_weapon(base: String, elem: String, mod: String, relic: String = "") -> Dictionary:
	var equip_comp = owner.get_node_or_null("EquipmentComponent")
	if equip_comp:
		equip_comp.equip_weapon(base, elem, mod, relic)
	
	var crafted_data = {
		"base": base,
		"element": elem,
		"modifier": mod,
		"relic": relic
	}
	SignalBus.item_crafted.emit(owner, crafted_data)
	return crafted_data
