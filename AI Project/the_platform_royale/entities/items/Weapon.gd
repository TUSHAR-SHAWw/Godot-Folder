class_name Weapon
extends ItemBase

@export var base_type: String = "Sword"
@export var element: String = "Fire"
@export var modifier: String = "Swift"
@export var relic: String = ""

func _init() -> void:
	item_type = "Weapon"
