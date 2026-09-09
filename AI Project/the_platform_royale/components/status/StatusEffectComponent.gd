class_name StatusEffectComponent
extends Node

var active_effects: Dictionary = {}

func apply_effect(effect_name: String, duration: float) -> void:
	active_effects[effect_name] = duration
	SignalBus.status_effect_applied.emit(owner, effect_name, duration)

func _process(delta: float) -> void:
	var keys = active_effects.keys()
	for key in keys:
		active_effects[key] -= delta
		
		# Apply continuous DOT ticks
		if key == "Burn":
			var health_comp = owner.get_node_or_null("HealthComponent")
			if health_comp:
				health_comp.take_damage(2.0 * delta)
		elif key == "Poison":
			var health_comp = owner.get_node_or_null("HealthComponent")
			if health_comp:
				health_comp.take_damage(4.0 * delta)
				
		if active_effects[key] <= 0:
			active_effects.erase(key)
