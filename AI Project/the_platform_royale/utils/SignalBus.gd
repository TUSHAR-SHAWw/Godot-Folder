extends Node

# Global Event Bus for decoupled signals across systems and components

# Player & Entity Signals
signal player_hunger_changed(player_id: String, hunger_val: float, hunger_stage: String)
signal player_health_changed(player_id: String, current_hp: float, max_hp: float)
signal entity_died(entity: Node, killer: Node)

# Round & Tower Signals
signal round_started(round_number: int, alive_players: int, total_floors: int)
signal round_phase_changed(new_phase: String)
signal round_ended(winner_id: String)
signal floor_collapse_warning(floors_to_remove: Array)
signal floors_collapsed(removed_count: int, remaining_floors: int)

# Combat & Crafting Signals
signal damage_dealt(target: Node, damage_data: Dictionary)
signal status_effect_applied(target: Node, effect_type: String, duration: float)
signal item_crafted(crafter: Node, item_data: Dictionary)
signal item_looted(collector: Node, item_data: Dictionary)
