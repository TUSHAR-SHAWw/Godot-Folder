class_name CombatComponent
extends Node

@export var attack_cooldown: float = 0.5
var can_attack: bool = true

func perform_attack(target: Node) -> void:
	if not can_attack or target == null:
		return
	
	can_attack = false
	
	var hunger_comp = owner.get_node_or_null("HungerComponent")
	var hunger_mult: float = 1.0
	if hunger_comp:
		hunger_mult = hunger_comp.get_stage_modifiers()["damage_mult"]
	
	var dmg_comp = owner.get_node_or_null("DamageComponent")
	if dmg_comp:
		var packet = dmg_comp.create_damage_packet(owner, hunger_mult)
		DamageCalculator.process_attack(target, packet)
	
	await owner.get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
