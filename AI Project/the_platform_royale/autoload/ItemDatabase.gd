extends Node

var weapon_bases = ["Sword", "Axe", "Bow", "Spear", "Dagger", "Staff", "Hammer"]
var elements = ["Fire", "Ice", "Lightning", "Poison", "Water", "Nature", "Shadow", "Light"]
var modifiers = ["Swift", "Heavy", "Sharp", "Leech", "Armor-piercing", "Balanced"]
var relics = ["Phoenix Heart", "Void Eye", "Titan Bone", "Chrono Shard"]

var lobby_items = [
	{"name": "Rope", "type": "mobility", "desc": "Allows vertical floor climbing"},
	{"name": "Medkit", "type": "consumable", "desc": "Restores 50 HP"},
	{"name": "Knife", "type": "weapon", "desc": "Basic starter weapon"},
	{"name": "Food Ration", "type": "food", "desc": "Restores 40 Hunger"},
	{"name": "Mobility Tool", "type": "mobility", "desc": "Grappling hook"},
	{"name": "Utility Item", "type": "utility", "desc": "Smoke bomb / flash"}
]

func get_random_weapon_base() -> String:
	return weapon_bases[randi() % weapon_bases.size()]

func get_random_element() -> String:
	return elements[randi() % elements.size()]
