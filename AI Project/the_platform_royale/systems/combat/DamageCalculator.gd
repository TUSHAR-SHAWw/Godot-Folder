class_name DamageCalculator
extends Node

static func process_attack(target: Node, damage_data: Dictionary) -> void:
	if target == null:
		return
	
	var health_comp = target.get_node_or_null("HealthComponent")
	if health_comp == null:
		return
	
	var raw_damage: float = damage_data.get("damage", 10.0)
	var element: String = damage_data.get("element", "Physical")
	var attacker: Node = damage_data.get("attacker", null)
	
	health_comp.take_damage(raw_damage, attacker)
	ElementSystem.apply_elemental_effect(target, element)
	
	SignalBus.damage_dealt.emit(target, damage_data)
