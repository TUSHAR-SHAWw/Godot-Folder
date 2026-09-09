class_name DamageComponent
extends Node

@export var base_damage: float = 10.0
@export var element_type: String = "Physical"
@export var crit_chance: float = 0.1
@export var crit_multiplier: float = 1.5

func create_damage_packet(attacker: Node, hunger_mult: float = 1.0) -> Dictionary:
	var is_crit = randf() <= crit_chance
	var final_dmg = base_damage * hunger_mult * (crit_multiplier if is_crit else 1.0)
	
	return {
		"attacker": attacker,
		"damage": final_dmg,
		"element": element_type,
		"is_crit": is_crit
	}
