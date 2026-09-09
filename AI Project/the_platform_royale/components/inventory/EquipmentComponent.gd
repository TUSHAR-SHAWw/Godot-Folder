class_name EquipmentComponent
extends Node

var weapon_base: String = "Dagger"
var primary_element: String = "Fire"
var secondary_modifier: String = "Swift"
var relic: String = "Phoenix Heart"

func get_full_weapon_build() -> Dictionary:
	return {
		"base": weapon_base,
		"element": primary_element,
		"modifier": secondary_modifier,
		"relic": relic
	}

func equip_weapon(base: String, elem: String, mod: String, rel: String = "") -> void:
	weapon_base = base
	primary_element = elem
	secondary_modifier = mod
	relic = rel
