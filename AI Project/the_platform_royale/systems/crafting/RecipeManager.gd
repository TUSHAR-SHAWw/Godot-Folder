class_name RecipeManager
extends Node

static func get_known_builds() -> Array:
	return [
		{"name": "Flame Assassin", "base": "Dagger", "element": "Fire", "modifier": "Swift", "relic": "Phoenix Heart"},
		{"name": "Ice Tank", "base": "Hammer", "element": "Ice", "modifier": "Heavy", "relic": "Titan Bone"},
		{"name": "Storm Ranger", "base": "Bow", "element": "Lightning", "modifier": "Armor-piercing", "relic": "Void Eye"}
	]
