class_name CraftingSystem
extends Node

static func build_weapon(base: String, elem: String, mod: String, relic: String) -> Dictionary:
	return {
		"weapon_name": elem + " " + mod + " " + base,
		"base": base,
		"element": elem,
		"modifier": mod,
		"relic": relic,
		"calculated_damage": _get_base_damage(base) * _get_mod_mult(mod)
	}

static func _get_base_damage(base: String) -> float:
	match base:
		"Hammer": return 30.0
		"Axe": return 25.0
		"Sword": return 20.0
		"Spear": return 18.0
		"Bow": return 15.0
		"Dagger": return 12.0
		"Staff": return 10.0
		_: return 15.0

static func _get_mod_mult(mod: String) -> float:
	match mod:
		"Heavy": return 1.3
		"Sharp": return 1.2
		"Swift": return 0.9
		"Armor-piercing": return 1.15
		_: return 1.0
