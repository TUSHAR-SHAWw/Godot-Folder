extends Node

func generate_floor_loot(floor_type: String) -> Array:
	var loot: Array = []
	match floor_type:
		"FeastFloor":
			loot.append({"type": "food", "name": "Feast Platter", "hunger_restore": 60})
			loot.append({"type": "food", "name": "Food Ration", "hunger_restore": 40})
		"ArmoryFloor":
			loot.append({"type": "weapon_base", "name": ItemDatabase.get_random_weapon_base()})
			loot.append({"type": "modifier", "name": ItemDatabase.modifiers[randi() % ItemDatabase.modifiers.size()]})
		"MedicalFloor":
			loot.append({"type": "consumable", "name": "Medkit", "hp_restore": 50})
			loot.append({"type": "consumable", "name": "Bandage", "hp_restore": 25})
		"LavaFloor":
			loot.append({"type": "element", "name": "Fire"})
			loot.append({"type": "relic", "name": "Phoenix Heart"})
		"GoldenFloor":
			loot.append({"type": "weapon_base", "name": "Hammer"})
			loot.append({"type": "element", "name": "Light"})
			loot.append({"type": "relic", "name": "Titan Bone"})
		_:
			# Common floor loot
			if randf() > 0.5:
				loot.append({"type": "food", "name": "Bread", "hunger_restore": 20})
			if randf() > 0.6:
				loot.append({"type": "element", "name": ItemDatabase.get_random_element()})
	return loot
