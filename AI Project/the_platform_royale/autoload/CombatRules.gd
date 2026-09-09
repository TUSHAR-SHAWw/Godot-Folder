extends Node

# Hunger Stage Multipliers
const HUNGER_STAGES = {
	"HIGH": {"min": 70.0, "damage_mult": 1.0, "defense_mult": 1.0, "speed_mult": 1.0},
	"MEDIUM": {"min": 40.0, "damage_mult": 1.15, "defense_mult": 1.0, "speed_mult": 1.0},
	"LOW": {"min": 15.0, "damage_mult": 1.40, "defense_mult": 0.85, "speed_mult": 1.05},
	"RAGE": {"min": 0.0, "damage_mult": 2.00, "defense_mult": 0.60, "speed_mult": 1.20}
}

func get_hunger_stage_data(hunger: float) -> Dictionary:
	if hunger >= HUNGER_STAGES["HIGH"].min:
		return HUNGER_STAGES["HIGH"]
	elif hunger >= HUNGER_STAGES["MEDIUM"].min:
		return HUNGER_STAGES["MEDIUM"]
	elif hunger >= HUNGER_STAGES["LOW"].min:
		return HUNGER_STAGES["LOW"]
	else:
		return HUNGER_STAGES["RAGE"]

func get_hunger_stage_name(hunger: float) -> String:
	if hunger >= HUNGER_STAGES["HIGH"].min:
		return "HIGH"
	elif hunger >= HUNGER_STAGES["MEDIUM"].min:
		return "MEDIUM"
	elif hunger >= HUNGER_STAGES["LOW"].min:
		return "LOW"
	else:
		return "RAGE"
