class_name CombatResolver
extends Node

static func resolve_pvp_clash(attacker: Node, defender: Node) -> Dictionary:
	var result = {"winner": null, "loser": null}
	var atk_hp = attacker.get_node_or_null("HealthComponent")
	var def_hp = defender.get_node_or_null("HealthComponent")
	
	if atk_hp and def_hp:
		if atk_hp.current_health > def_hp.current_health:
			result.winner = attacker
			result.loser = defender
		else:
			result.winner = defender
			result.loser = attacker
	return result
