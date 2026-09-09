class_name CraftingUI
extends Control

var selected_base: String = "Dagger"
var selected_element: String = "Fire"
var selected_modifier: String = "Swift"
var selected_relic: String = "Phoenix Heart"

func craft_current_selection(player: Node) -> void:
	var craft_comp = player.get_node_or_null("CraftingComponent")
	if craft_comp:
		craft_comp.craft_weapon(selected_base, selected_element, selected_modifier, selected_relic)
		print("[CraftingUI] Crafted: ", selected_element, " ", selected_modifier, " ", selected_base)
